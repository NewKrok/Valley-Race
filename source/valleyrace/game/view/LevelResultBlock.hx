package valleyrace.game.view;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.PlaceHolder;
import hpp.flixel.util.HPPAssetManager;
import hpp.util.NumberUtil;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelResultBlock extends FlxSpriteGroup
{
	var container:HPPHUIBox = new HPPHUIBox();

	var currentScoreLabelText:FlxText;
	var earnedStarView:FlxSprite;
	var earnedStarContainer:FlxSpriteGroup;

	public function new(currentScore:Float, starCount:UInt)
	{
		super();

		container = new HPPHUIBox();

		currentScoreLabelText = new FlxText(0, 0, 0, "W", 28); // "W" is just a placeholder to solve position problems after updateData
		currentScoreLabelText.autoSize = true;
		currentScoreLabelText.color = FlxColor.YELLOW;
		currentScoreLabelText.alignment = "left";
		currentScoreLabelText.font = Fonts.HOLLYWOOD;
		container.add(currentScoreLabelText);

		container.add(new PlaceHolder(320, 0));

		earnedStarContainer = new FlxSpriteGroup();
		earnedStarContainer.add(earnedStarView = HPPAssetManager.getSprite("large_star_" + starCount));
		container.add(earnedStarContainer);

		add(new PlaceHolder(573, 65, 0x44000000));
		add(container);

		updateData(currentScore, starCount);
	}

	public function updateData(currentScore:Float, starCount:UInt):Void
	{
		currentScoreLabelText.text = "SCORE: " + NumberUtil.formatNumber(currentScore);

		earnedStarContainer.remove(earnedStarView);
		earnedStarView.destroy();

		earnedStarContainer.add(earnedStarView = HPPAssetManager.getSprite("large_star_" + starCount));

		container.x = x + width / 2 - container.width / 2;
		container.y = y + height / 2 - container.height / 2;
	}
}