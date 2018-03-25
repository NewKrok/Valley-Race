package valleyrace;

import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AppConfig
{
	public static inline var GAME_NAME:String = "Valley_Race";
	public static inline var GAME_VERSION:String = "1.0.0";

	public static var WORLD_PIECE_SIZE:SimplePoint = { x: 5000, y: 2000 };
	public static var WORLD_BLOCK_SIZE:SimplePoint = { x: 500, y: 500 };

	public static var IS_ALPHA_ANIMATION_ENABLED:Bool = false;

	public static var MUSIC_VOLUME:Float = 1;
	public static var SOUND_VOLUME:Float = 1;

	public static var IS_SVG_FONT:Bool = false;
	public static var IS_MOBILE_DEVICE:Bool = false;
	public static var IS_DESKTOP_DEVICE(get, null):Bool;

	static function get_IS_DESKTOP_DEVICE():Bool
	{
		return !IS_MOBILE_DEVICE;
	}
}