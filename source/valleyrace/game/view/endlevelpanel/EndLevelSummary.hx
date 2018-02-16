package valleyrace.game.view.endlevelpanel;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPVUIBox;
import hpp.util.NumberUtil;
import valleyrace.assets.Fonts;
import valleyrace.datatype.LevelData;
import valleyrace.game.constant.CGameTimeValue;
import valleyrace.game.constant.CScore;
import valleyrace.game.view.counter.BonusCounter;
import valleyrace.game.view.counter.CoinCounter;
import valleyrace.game.view.counter.TimeCounter;
import valleyrace.util.SavedDataUtil.LevelInfo;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EndLevelSummary extends FlxSpriteGroup
{
	var levelInfo:LevelInfo;
	var levelData:LevelData;
	var totalScore:FlxText;

	var timeEntry:EndLevelEntry;
	var coinEntry:EndLevelEntry;
	var frontflipEntry:EndLevelEntry;
	var backflipEntry:EndLevelEntry;
	var wheelieEntry:EndLevelEntry;

	var coinCounter:CoinCounter;

	public function new(levelInfo:LevelInfo, levelData:LevelData)
	{
		super();
		scrollFactor.set();

		this.levelInfo = levelInfo;
		this.levelData = levelData;

		var background:FlxSprite = new FlxSprite().makeGraphic(400, 440, FlxColor.BLACK);
		background.alpha = .9;
		add(background);

		var title:FlxText = new FlxText(0, 0, background.width, "RACE COMPLETED ", 45);
		title.autoSize = true;
		title.color = FlxColor.YELLOW;
		title.font = Fonts.HOLLYWOOD;
		title.alignment = "center";
		title.y = 19;
		add(title);

		createDetails();
		createTotalScore();

		updateView(0, 0, 0, 0, 0, 0);
	}

	function createDetails():Void
	{
		var totalScoreContainer = new HPPVUIBox();
		totalScoreContainer.add(timeEntry = new EndLevelEntry(new TimeCounter(), true));
		totalScoreContainer.add(coinEntry = new EndLevelEntry(coinCounter = new CoinCounter()));
		totalScoreContainer.add(frontflipEntry = new EndLevelEntry(new BonusCounter("gui_frontflip_back"), true));
		totalScoreContainer.add(backflipEntry = new EndLevelEntry(new BonusCounter("gui_backflip_back")));
		totalScoreContainer.add(wheelieEntry = new EndLevelEntry(new BonusCounter("gui_wheelie_back"), true));

		totalScoreContainer.y = 70;
		add(totalScoreContainer);
	}

	function createTotalScore():Void
	{
		var totalScoreContainer = new HPPHUIBox();

		var totalScoreTitle = new FlxText(0, 0, "TOTAL SCORE ", 30);
		totalScoreTitle.autoSize = true;
		totalScoreTitle.color = 0xFF26FF92;
		totalScoreTitle.font = Fonts.HOLLYWOOD;
		totalScoreContainer.add(totalScoreTitle);

		totalScore = new FlxText(0, 0, 320, NumberUtil.formatNumber(levelInfo.score), 45);
		totalScore.autoSize = true;
		totalScore.color = FlxColor.YELLOW;
		totalScore.font = Fonts.HOLLYWOOD;
		totalScore.alignment = "center";
		totalScoreContainer.add(totalScore);

		totalScoreContainer.x = 24;
		totalScoreContainer.y = height - totalScoreContainer.height + 5;
		add(totalScoreContainer);
	}

	public function updateView(
		currentScore:UInt,
		currentTime:Float,
		currentCollectedCoins:UInt,
		countOfFrontFlip:UInt,
		countOfBackFlip:UInt,
		countOfNiceWheelie:UInt
	)
	{
		totalScore.text = NumberUtil.formatNumber(currentScore);

		timeEntry.setCounter(CGameTimeValue.MAXIMUM_GAME_TIME - currentTime);
		timeEntry.setValue(Math.floor(AppConfig.MAXIMUM_GAME_TIME_BONUS - currentTime / 10));

		coinCounter.setValue(currentCollectedCoins);
		coinCounter.setMaxValue(levelData.starPoints.length);
		coinEntry.setValue(currentCollectedCoins * AppConfig.COIN_SCORE_MULTIPLIER);
		coinEntry.setBonusValue(levelData.starPoints.length == currentCollectedCoins ? AppConfig.ALL_COINS_COLLECTED_BONUS : 0);

		frontflipEntry.setCounter(countOfFrontFlip);
		frontflipEntry.setValue(countOfFrontFlip * CScore.SCORE_FRONT_FLIP);

		backflipEntry.setCounter(countOfBackFlip);
		backflipEntry.setValue(countOfBackFlip * CScore.SCORE_BACK_FLIP);

		wheelieEntry.setCounter(countOfNiceWheelie);
		wheelieEntry.setValue(countOfNiceWheelie * CScore.SCORE_NICE_WHEELIE_TIME);
	}
}