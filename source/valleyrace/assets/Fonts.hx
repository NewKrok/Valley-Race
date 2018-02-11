package valleyrace.assets;

import openfl.Assets;
import openfl.text.Font;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Fonts
{
	public static var DEFAULT_FONT:String = "Verdana";
	public static var HOLLYWOOD(default, null):String;

	public static function init():Void
	{
		HOLLYWOOD = Assets.getFont("assets/fonts/Irresistible-Hollywood.ttf").fontName;
	}
}