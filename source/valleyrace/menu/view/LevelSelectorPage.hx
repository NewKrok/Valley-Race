package valleyrace.menu.view;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPUIGrid;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelSelectorPage extends FlxSpriteGroup
{
	var grid:HPPUIGrid;

	public function new(worldId:UInt, startIndex:UInt, endIndex:UInt)
	{
		super();

		build(worldId, startIndex, endIndex);
	}

	function build(worldId:UInt, startIndex:UInt, endIndex:UInt):Void
	{
		add(new FlxSprite().makeGraphic(FlxG.stage.stageWidth, FlxG.stage.stageHeight, FlxColor.TRANSPARENT));

		grid = new HPPUIGrid(4, 30, new FlxPoint(144, 124));

		for(i in startIndex...endIndex)
		{
			grid.add(new LevelButton(worldId, i, SavedDataUtil.getLevelInfo(worldId, i)));
		}

		grid.x = FlxG.stage.stageWidth / 2 - grid.width / 2;
		grid.y = FlxG.stage.stageHeight / 2 - grid.height / 2 - 70;

		add(grid);
	}
}