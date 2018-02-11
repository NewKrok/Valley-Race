package valleyrace.game.view;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.PlaceHolder;
import hpp.ui.VAlign;
import valleyrace.assets.Fonts;
import valleyrace.AppConfig;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CollectedCoinsInfoBlock extends FlxSpriteGroup
{
	var container:HPPHUIBox = new HPPHUIBox();

	var bonusText:FlxText;
	var bonusInfoText:FlxText;

	public function new(collectedCoins:UInt, maxCoinCount:UInt)
	{
		super();

		container = new HPPHUIBox(10, VAlign.MIDDLE);

		bonusText = new FlxText(0, 0, 0, "W", 28); // "W" is just a placeholder to solve position problems after updateData
		bonusText.autoSize = true;
		bonusText.color = FlxColor.YELLOW;
		bonusText.alignment = "left";
		bonusText.font = Fonts.HOLLYWOOD;
		container.add(bonusText);

		bonusInfoText = new FlxText(0, 0, 0, "W", 22); // "W" is just a placeholder to solve position problems after updateData
		bonusInfoText.autoSize = true;
		bonusInfoText.color = FlxColor.WHITE;
		bonusInfoText.alignment = "left";
		bonusInfoText.font = Fonts.HOLLYWOOD;
		container.add(bonusInfoText);

		add(new PlaceHolder(573, 45, 0x44000000));
		add(container);

		updateData(collectedCoins, maxCoinCount);
	}

	public function updateData(collectedCoins:UInt, maxCoinCount:UInt)
	{
		if (collectedCoins == maxCoinCount)
		{
			bonusText.text = "+" + AppConfig.ALL_COINS_COLLECTED_BONUS;
			bonusInfoText.text = "All coins collected bonus";
		}
		else
		{
			bonusText.text = "";
			bonusInfoText.text = "Collect all coins to reach bonus score";
		}

		container.rePosition();
		container.x = x + width / 2 - container.width / 2;
		container.y = y + height / 2 - container.height / 2;
	}
}