package valleyrace.game.view;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarMarker extends FlxSpriteGroup
{
	public function new()
	{
		super();

		var background = HPPAssetManager.getSprite("car_marker");
		background.x = -background.width / 2;
		background.y = -background.height;
		add(background);

		var info = new FlxText(0, 0, background.width, "YOUR CAR", 26);
		info.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		info.autoSize = true;
		info.alignment = "center";
		info.color = FlxColor.WHITE;
		info.font = Fonts.HOLLYWOOD;
		info.x = -background.width / 2;
		info.y = -background.height + 13;
		add(info);
	}
}