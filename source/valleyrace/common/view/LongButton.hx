package valleyrace.common.view;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.Fonts;
import openfl.Assets;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LongButton extends HPPButton
{
	public function new(title:String = "", callBack:HPPButton->Void = null)
	{
		super(title, callBack);

		label.font = Fonts.HOLLYWOOD;
		label.color = FlxColor.WHITE;
		labelSize = 25;
		labelOffsets = [new FlxPoint(0, -7), new FlxPoint(0, -7), new FlxPoint(0, -7)];
		loadGraphic(HPPAssetManager.getGraphic("base_button"));
		overScale = .98;
	}
}