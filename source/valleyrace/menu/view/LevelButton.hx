package valleyrace.menu.view;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPVUIBox;
import hpp.flixel.util.HPPAssetManager;
import hpp.util.NumberUtil;
import valleyrace.assets.Fonts;
import valleyrace.common.view.ExtendedButtonWithTween;
import valleyrace.common.view.ReachedStarView;
import valleyrace.state.GameState;
import valleyrace.util.SavedDataUtil.LevelSavedData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelButton extends ExtendedButtonWithTween
{
	var title:FlxText;
	var score:FlxText;
	var reachedStarView:ReachedStarView;

	var worldId:UInt;
	var levelId:UInt;

	public function new(worldId:UInt, levelId:UInt, levelInfo:LevelSavedData)
	{
		super(levelInfo.isEnabled ? loadLevel : null, "level_button_base");

		this.worldId = worldId;
		this.levelId = levelId;

		if (levelInfo.isEnabled)
		{
			overScale = .95;

			var container:HPPVUIBox = new HPPVUIBox(3);

			title = new FlxText(0, 0, cast width, (worldId < 2 ? "RACE " : "LEVEL ") + (levelId + 1), 35);
			title.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
			title.font = Fonts.HOLLYWOOD;
			title.color = 0xFF3E3700;
			title.alignment = "center";
			container.add(title);

			score = new FlxText(0, 0, title.width, levelInfo.score == 0 ? "PLAY" : NumberUtil.formatNumber(levelInfo.score), 35);
			score.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
			score.font = Fonts.HOLLYWOOD;
			score.color = FlxColor.WHITE;
			score.alignment = "center";
			container.add(score);

			container.add(reachedStarView = new ReachedStarView(true));
			reachedStarView.setStarCount(levelInfo.starCount);

			add(container);
			container.y = height / 2 - container.height / 2;
		}
		else add(HPPAssetManager.getSprite("level_button_locked"));
	}

	function loadLevel(target:HPPButton):Void
	{
		FlxG.switchState(new GameState(worldId, levelId));
	}
}