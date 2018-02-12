package valleyrace;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AppConfig
{
	public static inline var GAME_NAME:String = "ValleyRace";
	public static inline var GAME_VERSION:String = "0.0.1";

	public static inline var MAXIMUM_GAME_TIME_BONUS:Int = 10000;
	public static inline var COIN_SCORE_MULTIPLIER:Int = 25;
	public static inline var ALL_COINS_COLLECTED_BONUS:Int = 250;

	public static var IS_ALPHA_ANIMATION_ENABLED:Bool = false;

	public static var IS_MOBILE_DEVICE:Bool = false;
	public static var IS_DESKTOP_DEVICE(get, null):Bool;

	static function get_IS_DESKTOP_DEVICE():Bool
	{
		return !IS_MOBILE_DEVICE;
	}
}