package;

import lime.utils.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths {
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	static var currentLevel:String = "preload";

	inline static public function setCurrentLevel(name:String):Void
		currentLevel = name.toLowerCase();

	static function getPath(file:String, type:AssetType, library:Null<String>):String {
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null) {
			var levelPath = getLibraryPathForce(file, currentLevel);

			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");

			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload"):String
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);

	inline static function getLibraryPathForce(file:String, library:String):String
		return '$library:assets/$library/$file';

	inline static function getPreloadPath(file:String):String
		return 'assets/$file';

	inline static public function lua(key:String, ?library:String):String
		return getPath('data/$key.lua', TEXT, library);

	inline static public function hx(key:String, ?library:String):String
		return getPath('$key.hx', TEXT, library);

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String):String
		return getPath(file, type, library);

	inline static public function txt(key:String, ?library:String):String
		return getPath('data/$key.txt', TEXT, library);

	inline static public function xml(key:String, ?library:String):String
		return getPath('data/$key.xml', TEXT, library);

	inline static public function json(key:String, ?library:String):String
		return getPath('data/$key.json', TEXT, library);

	static public function video(key:String, ?ext:String = VIDEO_EXT):String
		return 'assets/videos/$key.$ext';

	static public function sound(key:String, ?library:String):String
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String):String
		return sound(key + FlxG.random.int(min, max), library);

	inline static public function music(key:String, ?library:String):String
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);

	inline static public function image(key:String, ?library:String):String
		return getPath('images/$key.png', IMAGE, library);

	inline static public function font(key:String):String
		return 'assets/fonts/$key';

	static public function voices(song:String, ?difficulty:String):String {
		if (difficulty != null) {
			if (Assets.exists('songs:assets/songs/${song.toLowerCase()}/Voices-$difficulty.$SOUND_EXT'))
				return 'songs:assets/songs/${song.toLowerCase()}/Voices-$difficulty.$SOUND_EXT';
		}

		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	static public function inst(song:String, ?difficulty:String):String {
		if (difficulty != null) {
			if (Assets.exists('songs:assets/songs/${song.toLowerCase()}/Inst-$difficulty.$SOUND_EXT'))
				return 'songs:assets/songs/${song.toLowerCase()}/Inst-$difficulty.$SOUND_EXT';
		}

		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	static public function songEvents(song:String, ?difficulty:String):String {
		if (difficulty != null) {
			if (Assets.exists(Paths.json("song data/" + song.toLowerCase() + '/events-${difficulty.toLowerCase()}')))
				return Paths.json("song data/" + song.toLowerCase() + '/events-${difficulty.toLowerCase()}');
		}

		return Paths.json("song data/" + song.toLowerCase() + "/events");
	}

	inline static public function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames {
		if (Assets.exists(file('images/$key.xml', library)))
			return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
		else
			return FlxAtlasFrames.fromSparrow(image("Bind_Menu_Assets", "preload"), file('images/Bind_Menu_Assets.xml', "preload"));
	}

	inline static public function getPackerAtlas(key:String, ?library:String):FlxAtlasFrames {
		if (Assets.exists(file('images/$key.txt', library)))
			return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
		else
			return FlxAtlasFrames.fromSparrow(image("Bind_Menu_Assets", "preload"), file('images/Bind_Menu_Assets.xml', "preload"));
	}
}
