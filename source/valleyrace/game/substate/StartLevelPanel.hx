package valleyrace.game.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPVUIBox;
import hpp.flixel.ui.PlaceHolder;
import hpp.ui.HAlign;
import hpp.util.NumberUtil;
import valleyrace.AppConfig;
import valleyrace.assets.Fonts;
import valleyrace.common.view.LongButton;
import valleyrace.common.view.SmallButton;
import valleyrace.util.LevelUtil;
import valleyrace.util.SavedDataUtil.LevelInfo;

/**
 * ...
 * @author Krisztian Somoracz
 */
class StartLevelPanel extends FlxSubState
{
	var content:HPPVUIBox;

	var startButton:HPPButton;
	var exitButton:HPPButton;
	var nextButton:HPPButton;
	var prevButton:HPPButton;

	var startRequest:HPPButton->Void;
	var exitRequest:HPPButton->Void;
	var nextLevelRequest:HPPButton->Void;
	var prevLevelRequest:HPPButton->Void;

	var baseBack:FlxSprite;
	var container:FlxSpriteGroup;
	var levelInfo:LevelInfo;

	function new(levelInfo:LevelInfo, startRequest:HPPButton->Void, exitRequest:HPPButton->Void, nextLevelRequest:HPPButton->Void, prevLevelRequest:HPPButton->Void):Void
	{
		super();

		this.levelInfo = levelInfo;
		this.startRequest = startRequest;
		this.exitRequest = exitRequest;
		this.nextLevelRequest = nextLevelRequest;
		this.prevLevelRequest = prevLevelRequest;
	}

	override public function create():Void
	{
		super.create();

		build();
	}

	function build():Void
	{
		buildHeader();
		buildFooter();
	}

	function canStartPrevLevel():Bool
	{
		return levelInfo.levelId != 0;
	}

	function canStartNextLevel():Bool
	{
		return levelInfo.isCompleted && levelInfo.levelId != 23;
	}

	function buildHeader():Void
	{
		var container:FlxSpriteGroup = new FlxSpriteGroup();
		container.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 100, FlxColor.BLACK);
		background.alpha = .8;
		container.add(background);

		var scoreContainer = new HPPHUIBox(15);
		var bestScoreLabelText:FlxText = new FlxText(0, 0, 0, "Best score ", 25);
		bestScoreLabelText.autoSize = true;
		bestScoreLabelText.color = FlxColor.WHITE;
		bestScoreLabelText.alignment = "left";
		bestScoreLabelText.font = Fonts.HOLLYWOOD;
		scoreContainer.add(bestScoreLabelText);
		var bestScoreText:FlxText = new FlxText(0, 0, 0, levelInfo.isCompleted ? NumberUtil.formatNumber(levelInfo.score) : "N/A", 25);
		bestScoreText.autoSize = true;
		bestScoreText.color = FlxColor.YELLOW;
		bestScoreText.alignment = "left";
		bestScoreText.font = Fonts.HOLLYWOOD;
		scoreContainer.add(bestScoreText);
		scoreContainer.x = 30;
		scoreContainer.y = 17;
		container.add(scoreContainer);

		var titleContainer:HPPVUIBox = new HPPVUIBox(-20, HAlign.RIGHT);
		var levelText:FlxText = new FlxText(0, 0, 0, "RACE " + (levelInfo.levelId + 1), 45);
		levelText.autoSize = true;
		levelText.color = 0xFFC9B501;
		levelText.font = Fonts.HOLLYWOOD;
		titleContainer.add(levelText);
		var worldText:FlxText = new FlxText(0, 0, 0, LevelUtil.getWorldNameByWorldId(levelInfo.worldId).toUpperCase(), 35);
		worldText.autoSize = true;
		worldText.color = 0xFFFFFF00;
		worldText.font = Fonts.HOLLYWOOD;
		titleContainer.add(worldText);
		titleContainer.x = FlxG.stage.stageWidth - titleContainer.width - 30;
		titleContainer.y = 17;
		container.add(titleContainer);

		add(container);
	}

	function buildFooter():Void
	{
		var container:FlxSpriteGroup = new FlxSpriteGroup();
		container.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 100, FlxColor.BLACK);
		background.alpha = .8;
		container.add(background);

		var buttonContainer:HPPHUIBox = new HPPHUIBox(30);

		buttonContainer.add(exitButton = new SmallButton(AppConfig.IS_DESKTOP_DEVICE ? "EXIT" : "EXIT", exitRequest));
		if (canStartPrevLevel()) buttonContainer.add(prevButton = new SmallButton(AppConfig.IS_DESKTOP_DEVICE ? "PREV LEVEL" : "PREVIOUS LEVEL", prevLevelRequest));
		if (canStartNextLevel()) buttonContainer.add(nextButton = new SmallButton(AppConfig.IS_DESKTOP_DEVICE ? "NEXT LEVEL" : "NEXT LEVEL", nextLevelRequest));

		buttonContainer.x = 30;
		buttonContainer.y = background.height / 2 - buttonContainer.height / 2;
		container.add(buttonContainer);
		container.add(startButton = new SmallButton(AppConfig.IS_DESKTOP_DEVICE ? "START GAME" : "START GAME", startRequest));
		startButton.x = FlxG.stage.stageWidth - startButton.width - 30;
		startButton.y = buttonContainer.y;

		container.add(buttonContainer);

		container.y = FlxG.stage.stageHeight - container.height;
		add(container);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (AppConfig.IS_DESKTOP_DEVICE)
		{
			if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.S)
			{
				startRequest(null);
			}

			if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.X)
			{
				exitRequest(null);
			}

			if (FlxG.keys.justPressed.P && canStartPrevLevel())
			{
				prevLevelRequest(null);
			}

			if (FlxG.keys.justPressed.N && canStartNextLevel())
			{
				nextLevelRequest(null);
			}
		}
	}
}