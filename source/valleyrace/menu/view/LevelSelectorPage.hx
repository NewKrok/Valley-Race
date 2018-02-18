package valleyrace.menu.view;

import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
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
		grid = new HPPUIGrid(5, 30, new FlxPoint(180, 179));

		for(i in startIndex...endIndex)
			grid.add(new LevelButton(worldId, i, SavedDataUtil.getLevelInfo(worldId, i)));

		add(grid);
	}
}