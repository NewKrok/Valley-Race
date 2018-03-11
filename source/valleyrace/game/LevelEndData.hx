package valleyrace.game;

import valleyrace.game.constant.CScore;
import valleyrace.util.ScoreUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LevelEndData
{
	public var totalScore:UInt;
	public var starCount:UInt;
	public var position:UInt;
	public var isUnlockedNextLevel:Bool;
	public var isHighscore:Bool;
	public var isLevelFinished:Bool;

	public var collectedCoin(default, set):UInt;
	public var gameTime(default, set):Float;
	public var countOfFrontFlip(default, set):UInt;
	public var countOfBackFlip(default, set):UInt;
	public var countOfNiceWheelie(default, set):UInt;
	public var isAllCoinCollected(default, set):Bool;
	public var isWon(default, set):Bool;

	public var coinCountForTime(default, null):UInt;
	public var coinCountForFrontFlip(default, null):UInt;
	public var coinCountForBackFlip(default, null):UInt;
	public var coinCountForWheelie(default, null):UInt;
	public var coinCountForMaxCoins(default, null):UInt;

	public var scoreForGameTime(default, null):UInt;
	public var scoreForCoin(default, null):UInt;
	public var scoreForFrontFlip(default, null):UInt;
	public var scoreForBackFlip(default, null):UInt;
	public var scoreForWheelie(default, null):UInt;

	public var totalCollectedCoin(get, null):UInt;

	public function new() {}

	function set_collectedCoin(v:UInt):UInt
	{
		collectedCoin = v;

		scoreForCoin = ScoreUtil.scoreFromCoin(v);

		return v;
	}

	function set_gameTime(v:Float):Float
	{
		gameTime = v;

		coinCountForTime = ScoreUtil.timeScoreToCoin(v);
		scoreForGameTime = ScoreUtil.scoreFromGameTime(v);

		return v;
	}

	function set_countOfFrontFlip(v:UInt):UInt
	{
		countOfFrontFlip = v;

		coinCountForFrontFlip = ScoreUtil.frontFlipCountToCoin(v);
		scoreForFrontFlip = ScoreUtil.scoreFromFrontFlip(v);

		return v;
	}

	function set_countOfBackFlip(v:UInt):UInt
	{
		countOfBackFlip = v;

		coinCountForBackFlip = ScoreUtil.backFlipCountToCoin(v);
		scoreForBackFlip = ScoreUtil.scoreFromBackFlip(v);

		return v;
	}

	function set_countOfNiceWheelie(v:UInt):UInt
	{
		countOfNiceWheelie = v;

		coinCountForWheelie = ScoreUtil.wheelieCountToCoin(v);
		scoreForWheelie = ScoreUtil.scoreFromWheelie(v);

		return v;
	}

	function set_isAllCoinCollected(v:Bool):Bool
	{
		isAllCoinCollected = v;

		coinCountForMaxCoins = v ? CScore.COIN_FOR_ALL_COINS_COLLECTED : 0;

		return v;
	}

	function get_totalCollectedCoin():UInt
	{
		return coinCountForBackFlip + coinCountForFrontFlip + coinCountForMaxCoins + coinCountForTime + coinCountForWheelie + collectedCoin;
	}

	function set_isWon(v:Bool):Bool
	{
		isWon = v;

		if (!v)
		{
			scoreForCoin = 0;
			scoreForFrontFlip = 0;
			scoreForBackFlip = 0;
			scoreForWheelie = 0;
			scoreForGameTime = 0;

			coinCountForTime = 0;
		}

		return v;
	}
}