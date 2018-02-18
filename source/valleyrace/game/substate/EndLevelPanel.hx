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
import valleyrace.common.view.SmallButton;
import valleyrace.datatype.LevelData;
import valleyrace.common.view.ReachedStarView;
import valleyrace.game.view.endlevelpanel.EndLevelSummary;
import valleyrace.util.LevelUtil;
import valleyrace.util.SavedDataUtil.LevelSavedData;


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

	var startButton:HPPButton;
	var exitButton:HPPButton;
	var nextButton:HPPButton;
	var prevButton:HPPButton;

	var restartRequest:HPPButton->Void;
	var exitRequest:HPPButton->Void;
	var nextLevelRequest:HPPButton->Void;
	var prevLevelRequest:HPPButton->Void;

	var bestScoreText:FlxText;
	var highscoreText:FlxText;

	var levelInfo:LevelSavedData;
	var levelData:LevelData;

	var isBuilt:Bool = false;
	var currentScore:UInt;
	var currentTime:Float;
	var currentCollectedCoins:UInt;
	var currentEarnedStarCounts:UInt;
	var countOfFrontFlip:UInt;
	var countOfBackFlip:UInt;
	var countOfNiceWheelie:UInt;

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

		updateView(
			currentScore,
			currentTime,
			currentCollectedCoins,
			currentEarnedStarCounts,
			countOfFrontFlip,
			countOfBackFlip,
			countOfNiceWheelie
		);
	}

	function build()
	{
		buildHeader();
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

		var scoreWrapper = new HPPVUIBox(0, HAlign.LEFT);
		var scoreContainer = new HPPHUIBox(15);

		var bestScoreLabelText:FlxText = new FlxText(0, 0, 0, "Best score ", 25);
		bestScoreLabelText.autoSize = true;
		bestScoreLabelText.color = FlxColor.WHITE;
		bestScoreLabelText.alignment = "left";
		bestScoreLabelText.font = Fonts.HOLLYWOOD;
		scoreContainer.add(bestScoreLabelText);
		bestScoreText = new FlxText(0, 0, 0, levelInfo.isCompleted ? NumberUtil.formatNumber(levelInfo.score) : "N/A", 25);
		bestScoreText.autoSize = true;
		bestScoreText.color = FlxColor.YELLOW;
		bestScoreText.alignment = "left";
		bestScoreText.font = Fonts.HOLLYWOOD;
		scoreContainer.add(bestScoreText);
		scoreWrapper.add(scoreContainer);

		highscoreText = new FlxText(0, 0, 0, "NEW HIGHSCORE! ", 25);
		highscoreText.autoSize = true;
		highscoreText.color = FlxColor.WHITE;
		highscoreText.alignment = "left";
		highscoreText.font = Fonts.HOLLYWOOD;
		highscoreText.visible = currentScore >= levelInfo.score;
		scoreContainer.add(highscoreText);

		reachedStarView = new ReachedStarView();
		scoreWrapper.add(reachedStarView);

		scoreWrapper.x = 30;
		scoreWrapper.y = 17;
		header.add(scoreWrapper);

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

		add(header);
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
		buttonContainer.add(exitButton = new SmallButton("RESTART", restartRequest));
		footer.add(buttonContainer);
		buttonContainer.x = 30;
		buttonContainer.y = (background.height - 50) / 2 - buttonContainer.height / 2;

		var buttonContainerRight:HPPHUIBox = new HPPHUIBox(30);
		if (canStartPrevLevel()) buttonContainerRight.add(prevButton = new SmallButton("PREV RACE", prevLevelRequest));
		if (canStartNextLevel()) buttonContainerRight.add(nextButton = new SmallButton("NEXT RACE", nextLevelRequest));
		buttonContainerRight.x = FlxG.stage.stageWidth - buttonContainerRight.width - 30;
		buttonContainerRight.y = (background.height - 50) / 2 - buttonContainer.height / 2;
		footer.add(buttonContainerRight);

		footer.y = FlxG.stage.stageHeight - footer.height + 50;
		add(footer);
	}

	function canStartPrevLevel():Bool
	{
		return levelInfo.levelId != 0;
	}

	function canStartNextLevel():Bool
	{
		return levelInfo.isCompleted && levelInfo.levelId != 23;
	}

	public function updateView(
		currentScore:UInt,
		currentTime:Float,
		currentCollectedCoins:UInt,
		currentEarnedStarCounts:UInt,
		countOfFrontFlip:UInt,
		countOfBackFlip:UInt,
		countOfNiceWheelie:UInt
	):Void
	{
		this.currentTime = currentTime;
		this.currentScore = currentScore;
		this.currentCollectedCoins = currentCollectedCoins;
		this.currentEarnedStarCounts = currentEarnedStarCounts;
		this.countOfFrontFlip = countOfFrontFlip;
		this.countOfBackFlip = countOfBackFlip;
		this.countOfNiceWheelie = countOfNiceWheelie;

		if (!isBuilt) return;

		reachedStarView.setStarCount(levelInfo.starCount);
		bestScoreText.text = NumberUtil.formatNumber(levelInfo.score);
		highscoreText.visible = currentScore >= levelInfo.score;

		endLevelSummary.updateView(currentScore, currentTime, currentCollectedCoins, countOfFrontFlip, countOfBackFlip, countOfNiceWheelie);
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
		}
	}
}