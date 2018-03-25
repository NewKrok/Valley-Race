package valleyrace.common.view;

import flixel.FlxG;
import flixel.addons.ui.ButtonLabelStyle;
import flixel.math.FlxPoint;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SmallButton extends ButtonWithTween
{
	public function new(title:String = "", callBack:HPPButton->Void = null)
	{
		super(title, function(e) {
			FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);
			callBack(e);
		});

		label.font = Fonts.HOLLYWOOD;
		labelSize = 30;
		up_style = new ButtonLabelStyle(null, null, 0xFF3E3700);
		over_style = new ButtonLabelStyle(null, null, 0xFFFFE302);
		if (!AppConfig.IS_SVG_FONT) labelOffsets = [new FlxPoint(0, 7), new FlxPoint(0, 7), new FlxPoint(0, 7)];
		loadGraphic(HPPAssetManager.getGraphic("base_button"));
		tweenOverScale = .95;
	}
}