package valleyrace.game.view.counter;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.Fonts;
import valleyrace.game.view.endlevelpanel.IValueContainer;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BonusCounter extends FlxSpriteGroup implements IValueContainer
{
	var background:FlxSprite;
	var text:FlxText;
	var count:UInt;

	public function new(backgroundUrl:String)
	{
		super();
		add(background = HPPAssetManager.getSprite(backgroundUrl));

		text = new FlxText(45, 0, cast width - 40, Std.string(0), 30);
		text.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		text.autoSize = false;
		text.color = FlxColor.WHITE;
		text.alignment = "center";
		text.font = Fonts.HOLLYWOOD;
		text.borderStyle = FlxTextBorderStyle.SHADOW;
		text.borderSize = 2;
		text.borderColor = 0x95000000;
		text.y = 13;

		add(text);
	}

	public function setValue(value:Float):Void
	{
		if (value != count)
		{
			count = Std.int(value);

			text.text = Std.string(value);
		}
	}
}