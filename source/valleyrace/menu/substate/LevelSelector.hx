package valleyrace.menu.substate;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPPager;
import hpp.flixel.ui.HPPTouchScrollContainer;
import valleyrace.common.view.LongButton;
import valleyrace.menu.view.LevelSelectorPage;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelSelector extends FlxSubState
{
	public var worldId:UInt;

	var levelButtonsContainer:HPPTouchScrollContainer;
	var controlButtonContainer:FlxSpriteGroup;

	var backButton:HPPButton;

	var onBackRequest:HPPButton->Void;
	var pager:HPPPager;

	function new( onBackRequest:HPPButton->Void ):Void
	{
		this.onBackRequest = onBackRequest;

		super();
	}

	override public function create():Void
	{
		super.create();

		createLevelButtons();
		createControlButtons();
		createPager();
	}

	function createLevelButtons()
	{
		add(levelButtonsContainer = new HPPTouchScrollContainer(FlxG.width, FlxG.height, new HPPTouchScrollContainerConfig({ snapToPages: true })));
		levelButtonsContainer.scrollFactor.set();

		var container:HPPHUIBox = new HPPHUIBox();
		container.add(new LevelSelectorPage(worldId, 0, 12));
		container.add(new LevelSelectorPage(worldId, 12, 24));

		levelButtonsContainer.add(container);

		var lastPlayedLevel:UInt = SavedDataUtil.getLastPlayedLevel(worldId);
		var isNextLevelEnabled:Bool = lastPlayedLevel == 23 ? false : SavedDataUtil.getLevelInfo(worldId, lastPlayedLevel + 1).isEnabled;
		if (lastPlayedLevel + (isNextLevelEnabled ? 1 : 0) > 11)
		{
			levelButtonsContainer.currentPage = 2;
		}

		openCallback = levelButtonsContainer.makeActive;
	}

	function createControlButtons()
	{
		add( controlButtonContainer = new FlxSpriteGroup() );
		controlButtonContainer.scrollFactor.set();

		controlButtonContainer.add( backButton = new LongButton( "BACK", onBackRequest ) );
		backButton.x = FlxG.width / 2 - backButton.width / 2;
		backButton.y = FlxG.height - 40 - backButton.height;
	}

	function createPager():Void
	{
		add( pager = new HPPPager( levelButtonsContainer, "pager_page", "pager_selected", 10 ) );
		pager.x = FlxG.width / 2 - pager.width / 2;
		pager.y = backButton.y - 40;
	}
}