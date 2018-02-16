package valleyrace.game.view.endlevelpanel;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.util.NumberUtil;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EndLevelEntry extends FlxSpriteGroup
{
	var valueText:FlxText;
	var bonusText:FlxText;
	var counter:IValueContainer;

	public function new(counter:IValueContainer, isWhite:Bool = false)
	{
		super();

		var background:FlxSprite = new FlxSprite().makeGraphic(400, 60, FlxColor.WHITE);
		background.alpha = isWhite ? .1 : 0;
		add(background);

		valueText = new FlxText(0, 0, background.width - 30, "W ", 30);
		valueText.autoSize = true;
		valueText.color = 0xFF26FF92;
		valueText.alignment = "right";
		valueText.font = Fonts.HOLLYWOOD;
		valueText.x = width - valueText.width - 28;
		valueText.y = 20;
		add(valueText);

		bonusText = new FlxText(0, 0, background.width - 30, "W ", 20);
		bonusText.autoSize = true;
		bonusText.color = FlxColor.WHITE;
		bonusText.alignment = "right";
		bonusText.font = Fonts.HOLLYWOOD;
		bonusText.x = width - valueText.width - 28;
		bonusText.y = 33;
		bonusText.visible = false;
		add(bonusText);

		this.counter = counter;
		counter.x = 24;
		counter.y = background.height / 2 - counter.height / 2;
		add(cast counter);
	}

	public function setValue(v:Float):Void
	{
		valueText.text = NumberUtil.formatNumber(v);
	}

	public function setCounter(v:Float):Void
	{
		counter.setValue(v);
	}

	public function setBonusValue(v:Float):Void
	{
		bonusText.text = "+" + NumberUtil.formatNumber(v) + " BONUS";
		bonusText.visible = v != 0;
		valueText.y = y + (bonusText.visible ? 10 : 20);
	}
}