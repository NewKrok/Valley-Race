package valleyrace.util;

import valleyrace.assets.CarDatas;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ShopHelper
{
	public static function isPossibleToBuySomething():Bool
	{
		var coin:UInt = SavedDataUtil.getPlayerInfo().coin;

		for (savedCardData in SavedDataUtil.getPlayerInfo().carDatas)
		{
			var cardData = CarDatas.getData(savedCardData.id);

			if (savedCardData.level + 1 < cardData.price.length && cardData.price[savedCardData.level + 1] <= coin)
				return true;
		}

		return false;
	}
}