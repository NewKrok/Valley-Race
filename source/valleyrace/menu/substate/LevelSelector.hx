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
import valleyrace.common.PlayerInfo;
import valleyrace.common.view.SmallButton;
import valleyrace.menu.view.CarPreview;
import valleyrace.menu.view.LevelSelectorPage;
import valleyrace.menu.view.PlayersCoin;
import valleyrace.util.LevelUtil;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelSelector extends FlxSubState
{
	public var worldId:UInt;

	var carPreviews:Array<CarPreview>;

	var header:FlxSpriteGroup;
	var footer:FlxSpriteGroup;
	var playersCoin:PlayersCoin;
	var contentHolder:HPPVUIBox;

	var onBackRequest:HPPButton->Void;

	function new(onBackRequest:HPPButton->Void):Void
	{
		this.onBackRequest = onBackRequest;
		carPreviews = [];

		super();
	}

	override public function create():Void
	{
		super.create();

		add(contentHolder = new HPPVUIBox(50));
		contentHolder.scrollFactor.set();

		buildHeader();
		contentHolder.add(new LevelSelectorPage(worldId, 0, 5));
		buildCarSelector();
		buildInfo();
		buildFooter();

		contentHolder.x = FlxG.stage.stageWidth / 2 - contentHolder.width / 2;
		contentHolder.y = FlxG.stage.stageHeight / 2 - contentHolder.height / 2;
	}

	function buildHeader():Void
	{
		header = new FlxSpriteGroup();
		header.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 66, FlxColor.BLACK);
		background.alpha = .5;
		header.add(background);

		header.add(playersCoin = new PlayersCoin(SavedDataUtil.getPlayerInfo().coin));
		playersCoin.x = 20;
		playersCoin.y = 8;

		var worldText:FlxText = new FlxText(0, 0, 0, LevelUtil.getWorldNameByWorldId(worldId).toUpperCase(), 35);
		worldText.autoSize = true;
		worldText.color = 0xFFFFFF00;
		worldText.font = Fonts.HOLLYWOOD;
		worldText.x = FlxG.stage.stageWidth - worldText.width - 30;
		worldText.y = 20;
		header.add(worldText);

		add(header);
	}

	function buildCarSelector()
	{
		var carSelectorContainer:HPPHUIBox = new HPPHUIBox(30);

		for (i in 0...3)
		{
			var preview = new CarPreview(onCarSelect, onCarUpgrade, i, PlayerInfo.selectedCarId == i);
			carSelectorContainer.add(preview);
			carPreviews.push(preview);
		}

		contentHolder.add(carSelectorContainer);
	}

	function onCarSelect(p:CarPreview)
	{
		for (preview in carPreviews)
			preview.isSelected = p == preview;

		PlayerInfo.selectedCarId = p.id;
	}

	function onCarUpgrade()
	{
		playersCoin.updateValue(SavedDataUtil.getPlayerInfo().coin);

		for (preview in carPreviews) preview.updateView();
	}

	function buildInfo()
	{
		var infoText = new FlxText(0, 0, 0, "Be the 1st to unlock the next level!", 30);
		infoText.color = FlxColor.WHITE;
		infoText.alignment = "center";
		infoText.font = Fonts.HOLLYWOOD;

		contentHolder.add(infoText);
	}

	function buildFooter():Void
	{
		footer = new FlxSpriteGroup();
		footer.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 80, FlxColor.BLACK);
		background.alpha = .5;
		footer.add(background);

		var backButton = new SmallButton("BACK", onBackRequest);
		backButton.x = background.width / 2 - backButton.width / 2;
		backButton.y = background.height - backButton.height - 12;
		footer.add(backButton);

		footer.y = FlxG.stage.stageHeight - footer.height;
		add(footer);
	}
}