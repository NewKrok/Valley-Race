package valleyrace.menu.view;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.util.HPPAssetManager;
import hpp.util.NumberUtil;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class PlayersCoin extends FlxSpriteGroup
{
	var levelText:FlxText;

	public function new(defaultValue:UInt = 0)
	{
		super(10);

		var coinView:FlxSprite = HPPAssetManager.getSprite("coin0000");
		add(coinView);

		levelText = new FlxText(0, 0, 0, NumberUtil.formatNumber(defaultValue), 35);
		levelText.autoSize = true;
		levelText.color = FlxColor.YELLOW;
		levelText.font = Fonts.HOLLYWOOD;
		levelText.x = coinView.width + 5;
		levelText.y = 5;
		add(levelText);
	}

	public function updateValue(v:UInt):Void
	{
		levelText.text = NumberUtil.formatNumber(v);
	}

	override function get_width():Float
	{
		return levelText != null ? levelText.x + levelText.width : 0;
	}

	override function get_height():Float
	{
		return levelText != null ? levelText.y + levelText.height : 0;
	}
}