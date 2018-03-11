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
import hpp.ui.HAlign;
import hpp.util.NumberUtil;
import valleyrace.AppConfig;
import valleyrace.assets.Fonts;
import valleyrace.common.view.ReachedStarView;
import valleyrace.common.view.SmallButton;
import valleyrace.common.view.WarningSign;
import valleyrace.datatype.LevelData;
import valleyrace.game.LevelEndData;
import valleyrace.game.view.endlevelpanel.EndLevelSummary;
import valleyrace.menu.view.CoinView;
import valleyrace.menu.view.RaceFinishPosition;
import valleyrace.util.LevelUtil;
import valleyrace.util.SavedDataUtil;
import valleyrace.util.SavedDataUtil.LevelSavedData;
import valleyrace.util.ShopHelper;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EndLevelPanel extends FlxSubState
{
	var header:FlxSpriteGroup;
	var footer:FlxSpriteGroup;
	var endLevelSummary:EndLevelSummary;
	var reachedStarView:ReachedStarView;
	var playersCoin:CoinView;
	var scoreContainer:HPPHUIBox;

	var startButton:HPPButton;
	var exitButton:HPPButton;
	var restartButton:HPPButton;
	var nextButton:HPPButton;
	var prevButton:HPPButton;

	var nextLevelWarning:WarningSign;
	var endLevelWarning:WarningSign;

	var restartRequest:HPPButton->Void;
	var exitRequest:HPPButton->Void;
	var nextLevelRequest:HPPButton->Void;
	var prevLevelRequest:HPPButton->Void;

	var title:FlxText;
	var bestScoreText:FlxText;
	var highscoreText:FlxText;

	var raceFinishPosition:RaceFinishPosition;

	var levelInfo:LevelSavedData;
	var levelData:LevelData;

	var isBuilt:Bool = false;
	var levelEndData:LevelEndData;

	function new(levelInfo:LevelSavedData, levelData:LevelData, restartRequest:HPPButton->Void, exitRequest:HPPButton->Void, nextLevelRequest:HPPButton->Void, prevLevelRequest:HPPButton->Void):Void
	{
		super();

		this.levelInfo = levelInfo;
		this.levelData = levelData;
		this.restartRequest = restartRequest;
		this.exitRequest = exitRequest;
		this.nextLevelRequest = nextLevelRequest;
		this.prevLevelRequest = prevLevelRequest;
	}

	override public function create():Void
	{
		super.create();

		build();
		isBuilt = true;

		updateView(levelEndData);
	}

	function build()
	{
		buildHeader();
		buildContent();
		buildFooter();
		add(endLevelSummary = new EndLevelSummary(levelInfo, levelData));
		endLevelSummary.y = 100;

	}

	function buildHeader():Void
	{
		header = new FlxSpriteGroup();
		header.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 150, FlxColor.BLACK);
		background.y = -50;
		background.alpha = .8;
		header.add(background);

		header.add(playersCoin = new CoinView(SavedDataUtil.getPlayerInfo().coin));
		playersCoin.x = 20;
		playersCoin.y = 17;

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
		header.add(titleContainer);

		title = new FlxText(0, 0, background.width, "RACE COMPLETED ", 45);
		title.autoSize = true;
		title.color = FlxColor.YELLOW;
		title.font = Fonts.HOLLYWOOD;
		title.alignment = "center";
		title.x = FlxG.stage.stageWidth / 2 - title.width / 2;
		title.y = 35;
		header.add(title);

		add(header);
	}

	function buildContent()
	{
		scoreContainer = new HPPHUIBox(15);
		scoreContainer.scrollFactor.set();

		var bestScoreLabelText:FlxText = new FlxText(0, 0, 0, "Best score ", 25);
		bestScoreLabelText.autoSize = true;
		bestScoreLabelText.color = FlxColor.WHITE;
		bestScoreLabelText.alignment = "left";
		bestScoreLabelText.font = Fonts.HOLLYWOOD;
		bestScoreLabelText.borderSize = 2;
		bestScoreLabelText.borderColor = FlxColor.BLACK;
		bestScoreLabelText.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		scoreContainer.add(bestScoreLabelText);
		bestScoreText = new FlxText(0, 0, 0, levelInfo.isCompleted ? NumberUtil.formatNumber(levelInfo.score) : "N/A", 25);
		bestScoreText.autoSize = true;
		bestScoreText.color = FlxColor.YELLOW;
		bestScoreText.alignment = "left";
		bestScoreText.font = Fonts.HOLLYWOOD;
		bestScoreText.borderSize = 2;
		bestScoreText.borderColor = FlxColor.BLACK;
		bestScoreText.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		scoreContainer.add(bestScoreText);

		scoreContainer.x = FlxG.stage.stageWidth - scoreContainer.width - 20;
		scoreContainer.y = FlxG.stage.stageHeight - scoreContainer.height - 100;
		add(scoreContainer);

		highscoreText = new FlxText(0, 0, 0, "NEW HIGHSCORE! ", 25);
		highscoreText.scrollFactor.set();
		highscoreText.autoSize = true;
		highscoreText.color = FlxColor.YELLOW;
		highscoreText.alignment = "left";
		highscoreText.font = Fonts.HOLLYWOOD;
		highscoreText.borderSize = 2;
		highscoreText.borderColor = FlxColor.BLACK;
		highscoreText.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		highscoreText.visible = levelEndData.isHighscore;
		highscoreText.x = FlxG.stage.stageWidth - highscoreText.width - 20;
		highscoreText.y = FlxG.stage.stageHeight - highscoreText.height - 130;
		add(highscoreText);

		add(raceFinishPosition = new RaceFinishPosition());
		raceFinishPosition.scrollFactor.set();
		raceFinishPosition.x = FlxG.stage.stageWidth - raceFinishPosition.width - 20;
		raceFinishPosition.y = 115;
	}

	function buildFooter():Void
	{
		footer = new FlxSpriteGroup();
		footer.scrollFactor.set();

		var background:FlxSprite = new FlxSprite().makeGraphic(1136, 150, FlxColor.BLACK);
		background.alpha = .8;
		footer.add(background);

		var buttonContainer:HPPHUIBox = new HPPHUIBox(30);
		buttonContainer.add(exitButton = new SmallButton("EXIT", exitRequest));
		buttonContainer.add(restartButton = new SmallButton("RESTART", restartRequest));
		footer.add(buttonContainer);
		buttonContainer.x = 30;
		buttonContainer.y = (background.height - 50) / 2 - buttonContainer.height / 2;

		var buttonContainerRight:HPPHUIBox = new HPPHUIBox(30);
		if (canStartPrevLevel()) buttonContainerRight.add(prevButton = new SmallButton("PREV RACE", prevLevelRequest));
		buttonContainerRight.add(nextButton = new SmallButton("NEXT RACE", nextLevelRequest));
		buttonContainerRight.x = FlxG.stage.stageWidth - buttonContainerRight.width - 30;
		buttonContainerRight.y = (background.height - 50) / 2 - buttonContainer.height / 2;
		if (!canStartNextLevel()) nextButton.visible = false;

		footer.add(buttonContainerRight);

		footer.add(endLevelWarning = new WarningSign());
		endLevelWarning.x = exitButton.x + exitButton.width;
		endLevelWarning.y = exitButton.y;

		footer.add(nextLevelWarning = new WarningSign());
		nextLevelWarning.x = nextButton.x + nextButton.width;
		nextLevelWarning.y = nextButton.y;

		footer.y = FlxG.stage.stageHeight - footer.height + 50;
		add(footer);
	}

	function canStartPrevLevel():Bool
	{
		return levelInfo.levelId != 0;
	}

	function canStartNextLevel():Bool
	{
		return levelInfo.isCompleted && levelInfo.levelId != 4;
	}

	public function updateView(levelEndData:LevelEndData):Void
	{
		this.levelEndData = levelEndData;

		if (!isBuilt) return;

		if (levelEndData.isWon)
		{
			title.text = "RACE COMPLETED";
			title.color = FlxColor.YELLOW;
		}
		else
		{
			title.text = "RACE FAILED";
			title.color = 0xFFFF4D4D;
		}

		playersCoin.updateValue(SavedDataUtil.getPlayerInfo().coin);

		bestScoreText.text = NumberUtil.formatNumber(levelInfo.score);
		scoreContainer.x = FlxG.stage.stageWidth - scoreContainer.width - 20;

		highscoreText.visible = levelEndData.isHighscore;

		endLevelSummary.updateView(levelEndData);
		raceFinishPosition.setFinishPosition(levelEndData.position, levelEndData.isUnlockedNextLevel);
		raceFinishPosition.visible = levelEndData.isLevelFinished;

		nextLevelWarning.visible = levelEndData.isUnlockedNextLevel;
		endLevelWarning.visible = ShopHelper.isPossibleToBuySomething();

		nextButton.visible = canStartNextLevel();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (AppConfig.IS_DESKTOP_DEVICE)
		{
			if (FlxG.keys.justPressed.R)
			{
				restartRequest(null);
			}

			if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.X)
			{
				exitRequest(null);
			}

			if (FlxG.keys.justPressed.P && canStartPrevLevel())
			{
				prevLevelRequest(null);
			}

			if ((FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.N) && canStartNextLevel())
			{
				nextLevelRequest(null);
			}

			if (FlxG.keys.justPressed.ENTER && !levelEndData.isWon && !levelInfo.isCompleted)
			{
				restartRequest(null);
			}
		}
	}
}