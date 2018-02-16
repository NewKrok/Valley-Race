package valleyrace.game.view.endlevelpanel;

import flixel.FlxSprite.IFlxSprite;

/**
 * @author Krisztian Somoracz
 */
interface IValueContainer extends IFlxSprite
{
	var height(get, set):Float;

	function setValue(value:Float):Void;
}