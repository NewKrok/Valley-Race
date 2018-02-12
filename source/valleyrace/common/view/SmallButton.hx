package valleyrace.common.view;

import flixel.addons.ui.ButtonLabelStyle;
import flixel.math.FlxPoint;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SmallButton extends HPPButton
{
	public function new(title:String = "", callBack:HPPButton->Void = null)
	{
		super(title, callBack);

		label.font = Fonts.HOLLYWOOD;
		labelSize = 30;
		up_style = new ButtonLabelStyle(null, null, 0xFF3E3700);
		over_style = new ButtonLabelStyle(null, null, 0xFFFFE302);
		labelOffsets = [new FlxPoint(0, 7), new FlxPoint(0, 7), new FlxPoint(0, 7)];
		loadGraphic(HPPAssetManager.getGraphic("base_button"));
		overScale = .95;
	}
}