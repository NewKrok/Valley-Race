package valleyrace.game.view.counter;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.util.HPPAssetManager;
import openfl.filters.GlowFilter;
import valleyrace.assets.Fonts;
import valleyrace.game.view.endlevelpanel.IValueContainer;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CoinCounter extends FlxSpriteGroup implements IValueContainer
{
	var background:FlxSprite;
	var backgroundActive:FlxSprite;
	var text:FlxText;
	var count:UInt;
	var maxValue:UInt = 99999;

	public function new(defaultValue:UInt = 0, maxValue:UInt = 0)
	{
		super();

		this.maxValue = maxValue;

		add(backgroundActive = HPPAssetManager.getSprite("gui_coin_back_max"));
		backgroundActive.visible = false;
		backgroundActive.alpha = 0;
		add(background = HPPAssetManager.getSprite("gui_coin_back"));

		backgroundActive.x = background.width / 2 - backgroundActive.width / 2;
		backgroundActive.y = background.height / 2 - backgroundActive.height / 2;

		text = new FlxText(45, 0, cast width - 40, Std.string(defaultValue) + " / " + maxValue, 30);
		text.autoSize = false;
		text.color = FlxColor.YELLOW;
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
		if(value != count)
		{
			count = Std.int(value);

			text.text = Std.string(value) + " / " + maxValue;
		}

		backgroundActive.visible = value == maxValue;
		backgroundActive.alpha = backgroundActive.visible ? 1 : 0;
	}

	public function setMaxValue(value:UInt):Void
	{
		maxValue = value;
	}

	override function get_width():Float
	{
		return background.width;
	}

	override function get_height():Float
	{
		return background.height;
	}
}