package valleyrace.game.view;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.Fonts;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class RaceFinishPosition extends FlxSpriteGroup
{
	var background:FlxSprite;
	var positionText:FlxText;
	var positionInfo:FlxText;

	public function new()
	{
		super();

		positionInfo = new FlxText(0, 0, 400, "W", 25);
		positionInfo.autoSize = true;
		positionInfo.alignment = "right";
		positionInfo.font = Fonts.HOLLYWOOD;
		positionInfo.borderSize = 2;
		positionInfo.borderColor = FlxColor.BLACK;
		positionInfo.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		positionInfo.y = 11;
		add(positionInfo);

		add(background = HPPAssetManager.getSprite("race_position_back"));
		background.x = 420;

		positionText = new FlxText(0, 0, background.width, "W", 40);
		positionText.autoSize = true;
		positionText.alignment = "center";
		positionText.font = Fonts.HOLLYWOOD;
		positionText.borderSize = 2;
		positionText.borderColor = 0xFF684511;
		positionText.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		positionText.x = background.x;
		positionText.y = 8;
		add(positionText);
	}

	public function setFinishPosition(p:UInt, isUnlockedNewLevel:Bool, worldId:UInt, collectedCoins:UInt, totalCoins:UInt):Void
	{
		if (worldId < 2)
		{
			positionText.color = p == 1 ? FlxColor.YELLOW : FlxColor.WHITE;
			positionText.text = p + " " + (p == 1 ? "ST" : p == 2 ? "ND" : p == 3 ? "RD" : "TH");
		}
		else
		{
			positionText.color = collectedCoins == totalCoins ? FlxColor.YELLOW : FlxColor.WHITE;
			positionText.text = collectedCoins + "/" + totalCoins;
		}

		positionInfo.color = positionText.color;

		if (p == 1)
			positionInfo.text = isUnlockedNewLevel ? (worldId < 2 ? "NEXT RACE UNLOCKED!" : "NEXT LEVEL UNLOCKED!") : "";
		else
			positionInfo.text = worldId < 2 ? "Be the 1st to unlock the next level!" : "Collect all coins to unlock next level!";
	}
}