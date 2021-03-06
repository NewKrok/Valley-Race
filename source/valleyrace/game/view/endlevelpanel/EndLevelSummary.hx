package valleyrace.game.view.endlevelpanel;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPVUIBox;
import hpp.flixel.ui.PlaceHolder;
import hpp.util.NumberUtil;
import valleyrace.assets.Fonts;
import valleyrace.common.view.ReachedStarView;
import valleyrace.datatype.LevelData;
import valleyrace.game.LevelEndData;
import valleyrace.game.constant.CGameTimeValue;
import valleyrace.game.constant.CScore;
import valleyrace.game.view.counter.BonusCounter;
import valleyrace.game.view.counter.CoinCounter;
import valleyrace.game.view.counter.TimeCounter;
import valleyrace.menu.view.CoinView;
import valleyrace.util.SavedDataUtil.LevelSavedData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EndLevelSummary extends FlxSpriteGroup
{
	var levelInfo:LevelSavedData;
	var levelData:LevelData;
	var totalScore:FlxText;
	var totalCoinView:CoinView;

	var timeEntry:EndLevelEntry;
	var coinEntry:EndLevelEntry;
	var frontflipEntry:EndLevelEntry;
	var backflipEntry:EndLevelEntry;
	var wheelieEntry:EndLevelEntry;

	var coinCounter:CoinCounter;
	var reachedStarView:ReachedStarView;

	public function new(levelInfo:LevelSavedData, levelData:LevelData)
	{
		super();
		scrollFactor.set();

		this.levelInfo = levelInfo;
		this.levelData = levelData;

		var background:FlxSprite = new FlxSprite().makeGraphic(480, 440, FlxColor.BLACK);
		background.alpha = .9;
		add(background);

		reachedStarView = new ReachedStarView();
		reachedStarView.x = background.width / 2 - reachedStarView.width / 2;
		reachedStarView.y = 19;
		add(reachedStarView);

		createDetails();
		createTotalScore();

		updateView(new LevelEndData());
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
		totalScoreTitle.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		totalScoreTitle.autoSize = true;
		totalScoreTitle.color = 0xFF26FF92;
		totalScoreTitle.font = Fonts.HOLLYWOOD;
		totalScoreContainer.add(totalScoreTitle);

		totalScore = new FlxText(0, 0, 160, NumberUtil.formatNumber(levelInfo.score), 45);
		totalScore.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		totalScore.autoSize = true;
		totalScore.color = FlxColor.YELLOW;
		totalScore.font = Fonts.HOLLYWOOD;
		totalScore.alignment = "right";
		totalScoreContainer.add(totalScore);

		totalScoreContainer.x = 24;
		totalScoreContainer.y = height - totalScoreContainer.height + 5;
		add(totalScoreContainer);

		totalCoinView = new CoinView(0, .7);
		totalCoinView.x = 360;
		totalCoinView.y = 387;
		add(totalCoinView);
	}

	public function updateView(levelEndData:LevelEndData)
	{
		reachedStarView.setStarCount(levelEndData.starCount);

		totalScore.text = NumberUtil.formatNumber(levelEndData.totalScore);
		totalCoinView.updateValue(levelEndData.totalCollectedCoin);

		timeEntry.setCounter(CGameTimeValue.MAXIMUM_GAME_TIME - levelEndData.gameTime);
		timeEntry.setCoinValue(levelEndData.coinCountForTime);
		timeEntry.setValue(levelEndData.scoreForGameTime);

		coinCounter.setValue(levelEndData.collectedCoin);
		coinCounter.setMaxValue(levelData.collectableItems.length);
		coinEntry.setValue(levelEndData.scoreForCoin);
		coinEntry.setCoinValue(levelEndData.collectedCoin + levelEndData.coinCountForMaxCoins);
		coinEntry.setBonusValue(levelEndData.isAllCoinCollected ? CScore.ALL_COINS_COLLECTED_BONUS_SCORE : 0);

		frontflipEntry.setCounter(levelEndData.countOfFrontFlip);
		frontflipEntry.setValue(levelEndData.scoreForFrontFlip);
		frontflipEntry.setCoinValue(levelEndData.coinCountForFrontFlip);

		backflipEntry.setCounter(levelEndData.countOfBackFlip);
		backflipEntry.setValue(levelEndData.scoreForBackFlip);
		backflipEntry.setCoinValue(levelEndData.coinCountForBackFlip);

		wheelieEntry.setCounter(levelEndData.countOfNiceWheelie);
		wheelieEntry.setValue(levelEndData.scoreForWheelie);
		wheelieEntry.setCoinValue(levelEndData.coinCountForWheelie);
	}
}