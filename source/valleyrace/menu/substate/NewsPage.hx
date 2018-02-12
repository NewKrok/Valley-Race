package valleyrace.menu.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPTouchScrollContainer;
import hpp.flixel.ui.HPPVUIBox;
import valleyrace.assets.Fonts;
import valleyrace.common.view.LongButton;

/**
 * ...
 * @author Krisztian Somoracz
 */
class NewsPage extends FlxSubState
{
	var openWelcomePage:HPPButton->Void;

	var backButton:HPPButton;

	function new(openWelcomePage:HPPButton->Void):Void
	{
		super();

		this.openWelcomePage = openWelcomePage;
	}

	override public function create():Void
	{
		super.create();

		build();
	}

	function build()
	{
		var baseBack:FlxSprite = new FlxSprite();
		baseBack.makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
		baseBack.scrollFactor.set();
		add(baseBack);

		add(createTitle());

		var container:HPPVUIBox = new HPPVUIBox(20);
		container.scrollFactor.set();

		var scrollContainerConfig:HPPTouchScrollContainerConfig = new HPPTouchScrollContainerConfig();
		scrollContainerConfig.snapToPages = false;
		scrollContainerConfig.direction = HPPScrollDirection.VERTICAL;
		var scrollContainer:HPPTouchScrollContainer = new HPPTouchScrollContainer(1136, 410, scrollContainerConfig);

		container.add(createEntry("???", "???"));

		scrollContainer.add(container);
		scrollContainer.x = 25;
		scrollContainer.y = 95;
		add(scrollContainer);

		add(backButton = new LongButton("BACK", openWelcomePage));
		backButton.x = FlxG.width / 2 - backButton.width / 2;
		backButton.y = FlxG.height - 40 - backButton.height;

		openCallback = scrollContainer.makeActive;
	}

	function createTitle():FlxText
	{
		var text = new FlxText();
		text.scrollFactor.set();

		text.color = FlxColor.CYAN;
		text.alignment = "center";
		text.size = 40;
		text.font = Fonts.HOLLYWOOD;
		text.borderStyle = FlxTextBorderStyle.SHADOW;
		text.fieldWidth = FlxG.width;
		text.text = "LATEST NEWS";
		text.y = 40;

		return text;
	}

	function createEntry(version:String, description:String):FlxSpriteGroup
	{
		var entryContainer:HPPVUIBox = new HPPVUIBox(5);

		var versionText = new FlxText();
		versionText.color = FlxColor.WHITE;
		versionText.alignment = "center";
		versionText.size = 30;
		versionText.font = Fonts.HOLLYWOOD;
		versionText.borderStyle = FlxTextBorderStyle.OUTLINE;
		versionText.text = version;
		entryContainer.add(versionText);

		var descText = new FlxText();
		descText.color = FlxColor.WHITE;
		descText.alignment = "center";
		descText.size = 25;
		descText.font = Fonts.HOLLYWOOD;
		versionText.borderStyle = FlxTextBorderStyle.OUTLINE;
		descText.text = description;
		descText.wordWrap = true;
		descText.fieldWidth = FlxG.width - 50;
		entryContainer.add(descText);

		return entryContainer;
	}
}