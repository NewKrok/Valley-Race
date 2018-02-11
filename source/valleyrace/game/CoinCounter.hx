package valleyrace.game;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.misc.VarTween;
import flixel.util.FlxColor;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CoinCounter extends FlxSpriteGroup
{
	var background:FlxSprite;
	var text:FlxText;
	var defaultTextScale:Float;
	var count:UInt;
	var scaleTween:VarTween;
	var maxValue:UInt;

	public function new(defaultValue:UInt = 0, maxValue:UInt = 0)
	{
		super();

		this.maxValue = maxValue;

		add(background = HPPAssetManager.getSprite("gui_coin_back"));

		text = new FlxText(45, 0, cast width - 40, Std.string(defaultValue) + " / " + maxValue, 30);
		text.autoSize = false;
		text.color = FlxColor.YELLOW;
		text.alignment = "center";
		text.font = Fonts.HOLLYWOOD;
		text.borderStyle = FlxTextBorderStyle.SHADOW;
		text.borderSize = 2;
		text.borderColor = 0x95000000;
		text.y = 13;
		defaultTextScale = text.scale.x;

		add(text);
	}

	public function updateValue(value:UInt):Void
	{
		if(value != count)
		{
			count = value;

			text.text = Std.string(value) + " / " + maxValue;
		}
	}
}