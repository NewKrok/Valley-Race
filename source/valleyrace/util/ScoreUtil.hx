package valleyrace.util;

import valleyrace.AppConfig;
import valleyrace.game.LevelEndData;
import valleyrace.game.constant.CGameTimeValue;
import valleyrace.game.constant.CScore;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ScoreUtil
{
	static public function timeScoreToCoin(v:Float):UInt
	{
		return Math.floor((CGameTimeValue.MAXIMUM_GAME_TIME - v) * CScore.TIME_SCORE_TO_COIN_MULTIPLIER);
	}

	static public function frontFlipCountToCoin(v:UInt):UInt
	{
		return v * CScore.COIN_FOR_FRONT_FLIP;
	}

	static public function backFlipCountToCoin(v:UInt):UInt
	{
		return v * CScore.COIN_FOR_BACK_FLIP;
	}

	static public function wheelieCountToCoin(v:UInt):UInt
	{
		return v * CScore.COIN_FOR_WHEELIE;
	}

	static public function scoreFromGameTime(v:Float):UInt
	{
		return Math.floor(CScore.MAXIMUM_GAME_TIME_BONUS_SCORE - v * CScore.GAME_TIME_BONUS_SCORE_MULTIPLIER);
	}

	static public function scoreFromCoin(v:UInt):UInt
	{
		return v * CScore.COIN_SCORE_MULTIPLIER;
	}

	static public function scoreFromFrontFlip(v:UInt):UInt
	{
		return v * CScore.SCORE_FRONT_FLIP;
	}

	static public function scoreFromBackFlip(v:UInt):UInt
	{
		return v * CScore.SCORE_BACK_FLIP;
	}

	static public function scoreFromWheelie(v:UInt):UInt
	{
		return v * CScore.SCORE_NICE_WHEELIE_TIME;
	}

	static public function calculateTotalScore(levelEndData:LevelEndData):UInt
	{
		var result:UInt = 0;

		result = scoreFromGameTime(levelEndData.gameTime);
		result += scoreFromCoin(levelEndData.collectedCoin);
		result += levelEndData.isAllCoinCollected ? CScore.ALL_COINS_COLLECTED_BONUS_SCORE : 0;
		result += scoreFromFrontFlip(levelEndData.countOfFrontFlip);
		result += scoreFromBackFlip(levelEndData.countOfBackFlip);
		result += scoreFromWheelie(levelEndData.countOfNiceWheelie);

		return result;
	}

	static public function scoreToStarCount(score:UInt, starValues:Array<UInt>):UInt
	{
		var starCount:UInt = 0;

		for (i in 0...starValues.length)
		{
			if (score >= starValues[i]) starCount = i + 1;
			else return starCount;
		}

		return starCount;
	}
}