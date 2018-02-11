package valleyrace.menu.view;
import valleyrace.util.SavedDataUtil;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPExtendableButton;
import hpp.flixel.ui.HPPVUIBox;
import hpp.flixel.util.HPPAssetManager;
import hpp.util.NumberUtil;
import valleyrace.assets.Fonts;
import valleyrace.state.GameState;
import valleyrace.util.SavedDataUtil.LevelInfo;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelButton extends HPPExtendableButton
{
	var title:FlxText;
	var score:FlxText;
	var levelStarView:LevelStarView;

	var worldId:UInt;
	var levelId:UInt;

	public function new(worldId:UInt, levelId:UInt, levelInfo:LevelInfo)
	{
		super(levelInfo.isEnabled ? loadLevel : null, "level_button_base");

		this.worldId = worldId;
		this.levelId = levelId;

		if (levelInfo.isEnabled)
		{
			overScale = .95;

			var container:HPPVUIBox = new HPPVUIBox(6);

			title = new FlxText(0, 0, cast width, "Level " + (levelId + 1), 25);
			title.font = Fonts.HOLLYWOOD;
			title.color = FlxColor.WHITE;
			title.alignment = "center";
			container.add(title);

			container.add(levelStarView = new LevelStarView());
			levelStarView.setStarCount(levelInfo.starCount);

			score = new FlxText(0, 0, title.width, NumberUtil.formatNumber(levelInfo.score), 25);
			score.font = Fonts.HOLLYWOOD;
			score.color = FlxColor.YELLOW;
			score.alignment = "center";
			container.add(score);

			add(container);

			container.y = 9;
		}
		else add(HPPAssetManager.getSprite("level_button_locked"));
	}

	function loadLevel(target:HPPButton):Void
	{
		FlxG.switchState(new GameState(worldId, levelId));
	}
}