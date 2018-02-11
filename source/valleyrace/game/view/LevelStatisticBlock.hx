package valleyrace.game.view;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPVUIBox;
import hpp.flixel.ui.PlaceHolder;
import hpp.flixel.util.HPPAssetManager;
import hpp.ui.VAlign;
import hpp.util.TimeUtil;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelStatisticBlock extends FlxSpriteGroup
{
	var container:HPPHUIBox = new HPPHUIBox();

	var coinText:FlxText;
	var timeText:FlxText;

	public function new(collectedCoins:UInt, maxCoinCount:UInt, currentTime:Float)
	{
		super();

		container = new HPPHUIBox(10, VAlign.MIDDLE);

		container.add(HPPAssetManager.getSprite("coin_icon"));
		var coinBox:HPPVUIBox = new HPPVUIBox();
		coinBox.add(new PlaceHolder(1, 4));
		coinText = new FlxText(0, 0, 0, "W", 28); // "W" is just a placeholder to solve position problems after updateData
		coinText.color = FlxColor.YELLOW;
		coinText.alignment = "left";
		coinText.font = Fonts.HOLLYWOOD;
		coinBox.add(coinText);
		container.add(coinBox);

		container.add(new PlaceHolder(30, 1));

		container.add(HPPAssetManager.getSprite("time_icon"));
		var timeBox:HPPVUIBox = new HPPVUIBox();
		timeBox.add(new PlaceHolder(1, 4));
		timeText = new FlxText(0, 0, 0, "W", 28); // "W" is just a placeholder to solve position problems after updateData
		timeText.color = 0xFF26FF92;
		timeText.alignment = "left";
		timeText.font = Fonts.HOLLYWOOD;
		timeBox.add(timeText);
		container.add(timeBox);

		add(new PlaceHolder(573, 55, 0x44000000));
		add(container);

		updateData(collectedCoins, maxCoinCount, currentTime);
	}

	public function updateData(collectedCoins:UInt, maxCoinCount:UInt, currentTime:Float)
	{
		coinText.text = collectedCoins + "/" + maxCoinCount;
		timeText.text = TimeUtil.timeStampToFormattedTime(currentTime, TimeUtil.TIME_FORMAT_MM_SS);

		container.rePosition();
		container.x = x + width / 2 - container.width / 2;
		container.y = y + height / 2 - container.height / 2;
	}
}