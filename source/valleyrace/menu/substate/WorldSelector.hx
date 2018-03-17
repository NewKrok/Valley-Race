package valleyrace.menu.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPVUIBox;
import valleyrace.assets.Fonts;
import valleyrace.common.view.SmallButton;
import valleyrace.menu.view.ChallengeWorldButton;
import valleyrace.menu.view.CoinView;
import valleyrace.menu.view.WorldButton;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WorldSelector extends FlxSubState
{
	var header:FlxSpriteGroup;
	var footer:FlxSpriteGroup;
	var playersCoin:CoinView;

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

		buildHeader();
		buildLevelPackButtons();
		buildFooter();
	}

	function buildHeader():Void
	{
		header = new FlxSpriteGroup();
		header.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 66, FlxColor.BLACK);
		background.alpha = .5;
		header.add(background);

		header.add(playersCoin = new CoinView(SavedDataUtil.getPlayerInfo().coin));
		playersCoin.x = 20;
		playersCoin.y = 15;

		var infoText:FlxText = new FlxText(0, 0, 0, "SELECT AREA", 35);
		infoText.autoSize = true;
		infoText.color = 0xFFFFFF00;
		infoText.font = Fonts.HOLLYWOOD;
		infoText.x = FlxG.stage.stageWidth - infoText.width - 30;
		infoText.y = 20;
		header.add(infoText);

		add(header);
	}

	function buildFooter():Void
	{
		footer = new FlxSpriteGroup();
		footer.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 80, FlxColor.BLACK);
		background.alpha = .5;
		footer.add(background);

		var backButton = new SmallButton("BACK", openWelcomePage);
		backButton.x = background.width / 2 - backButton.width / 2;
		backButton.y = background.height - backButton.height - 12;
		footer.add(backButton);

		footer.y = FlxG.stage.stageHeight - footer.height;
		add(footer);
	}

	function buildLevelPackButtons():Void
	{
		var wrapper = new HPPHUIBox(10);
		wrapper.scrollFactor.set();

		var levelPackButtonContainer:HPPVUIBox = new HPPVUIBox(10);
		levelPackButtonContainer.scrollFactor.set();

		levelPackButtonContainer.add(new WorldButton(0, function() {onWorldSelected(0);}, "world_0_selector_back"));
		levelPackButtonContainer.add(new WorldButton(1, function() {onWorldSelected(1);}, "world_1_selector_back"));

		wrapper.add(levelPackButtonContainer);

		wrapper.add(new ChallengeWorldButton(2, function() {onWorldSelected(2); }, "world_2_selector_back"));

		wrapper.x = FlxG.stage.stageWidth / 2 - wrapper.width / 2;
		wrapper.y = FlxG.stage.stageHeight / 2 - wrapper.height / 2 - 10;

		add(wrapper);
	}
}