package valleyrace.menu.substate;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPUIGrid;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.common.view.LongButton;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WorldSelector extends FlxSubState
{
	var levelPackButtonContainer:HPPUIGrid;
	var controlButtonContainer:FlxSpriteGroup;

	var levelPackButton0:HPPButton;
	var levelPackButton1:HPPButton;
	var levelPackButton2:HPPButton;
	var levelPackButton3:HPPButton;

	var backButton:HPPButton;

	var onWorldSelected:UInt->Void;
	var openWelcomePage:HPPButton->Void;

	function new( openWelcomePage:HPPButton->Void, onWorldSelected:UInt->Void ):Void
	{
		this.openWelcomePage = openWelcomePage;
		this.onWorldSelected = onWorldSelected;

		super();
	}

	override public function create():Void
	{
		super.create();

		createLevelPackButtons();
		createControlButtons();
	}

	function createLevelPackButtons():Void
	{
		add( levelPackButtonContainer = new HPPUIGrid( 2, 20 ) );
		levelPackButtonContainer.scrollFactor.set();

		levelPackButtonContainer.add( levelPackButton0 = new HPPButton( "", loadWorld0, "level_pack_0" ) );
		levelPackButton0.overScale = .98;

		levelPackButtonContainer.add( levelPackButton1 = new HPPButton( "", loadWorld1, "level_pack_1" ) );
		levelPackButton1.overScale = .98;

		levelPackButtonContainer.add( levelPackButton2 = new HPPButton( "", loadWorld2, "level_pack_coming_soon"/*"level_pack_2"*/ ) );
		//levelPackButton2.overScale = .98;

		levelPackButtonContainer.add( levelPackButton3 = new HPPButton( "", loadWorld3, "level_pack_coming_soon" ) );
		//levelPackButton3.overScale = .98;

		levelPackButtonContainer.x = FlxG.width / 2 - levelPackButtonContainer.width / 2;
		levelPackButtonContainer.y = FlxG.height / 2 - levelPackButtonContainer.height / 2 - 50;
	}

	function loadWorld0(target:HPPButton):Void
	{
		onWorldSelected(0);
	}

	function loadWorld1( target:HPPButton ):Void
	{
		onWorldSelected(1);
	}

	function loadWorld2( target:HPPButton ):Void
	{
		//onWorldSelected(2);
	}

	function loadWorld3( target:HPPButton ):Void
	{
		//onWorldSelected(3);
	}

	function createControlButtons()
	{
		add( controlButtonContainer = new FlxSpriteGroup() );
		controlButtonContainer.scrollFactor.set();

		controlButtonContainer.add( backButton = new LongButton( "BACK", openWelcomePage ) );
		backButton.x = FlxG.width / 2 - backButton.width / 2;
		backButton.y = FlxG.height - 40 - backButton.height;
	}
}