package valleyrace.menu.view;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.util.HPPAssetManager;
import hpp.util.NumberUtil;
import valleyrace.assets.Fonts;
import valleyrace.common.view.ExtendedButtonWithTween;
import valleyrace.datatype.CarData;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class UpgradeButton extends ExtendedButtonWithTween
{
	var container:HPPHUIBox;
	var priceContainer:FlxSpriteGroup;
	var title:FlxText;
	var priceText:FlxText;

	var onUpgrade:Void->Void;
	var isUnlocked:Bool;
	var level:UInt;
	var carData:CarData;

	public function new(onUpgrade:Void->Void, isUnlocked:Bool, level:UInt, carData:CarData)
	{
		super(onUpgradeRequest, "upgrade_button");

		this.onUpgrade = onUpgrade;
		this.isUnlocked = isUnlocked;
		this.level = level;
		this.carData = carData;

		container = new HPPHUIBox(2);

		title = new FlxText(0, 0, 0, "W", 20);
		title.offset.set(0, AppConfig.IS_SVG_FONT ? 5 : 0);
		title.autoSize = true;
		title.font = Fonts.HOLLYWOOD;
		title.color = 0xFF3E3700;
		title.alignment = "center";

		if (level < carData.price.length - 1)
		{
			priceContainer = new FlxSpriteGroup();
			var coinView:FlxSprite = HPPAssetManager.getSprite("coin_small");
			coinView.y = -1;
			priceContainer.add(coinView);

			priceText = new FlxText(0, 0, 0, NumberUtil.formatNumber(carData.price[level + 1]), 20);
			priceText.offset.set(0, AppConfig.IS_SVG_FONT ? 5 : 0);
			priceText.autoSize = true;
			priceText.color = FlxColor.YELLOW;
			priceText.font = Fonts.HOLLYWOOD;
			priceText.x = coinView.width + 1;
			priceContainer.add(priceText);

			container.add(priceContainer);

			title.text = isUnlocked ? "UPGRADE" : "UNLOCK";
			title.size = 18;

			if (SavedDataUtil.getPlayerInfo().coin < carData.price[level + 1])
				alpha = .5;
			else
				overScale = .95;
		}
		else title.text = "MAX";

		container.add(title);

		container.x = width / 2 - container.width / 2;
		container.y = 5;
		add(container);
	}

	function onUpgradeRequest(_)
	{
		if (carData.price.length > level && SavedDataUtil.getPlayerInfo().coin >= carData.price[level + 1])
		{
			FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);
			onUpgrade();
		}
	}

	public function updateView(isUnlocked:Bool, level:UInt):Void
	{
		if (SavedDataUtil.getPlayerInfo().coin < carData.price[level + 1])
		{
			alpha = .5;
			overScale = 1;
		}
		else if (level < carData.price.length - 1)
			overScale = .95;

		if (this.level != level || this.isUnlocked != isUnlocked)
		{
			this.level = level;

			if (level < carData.price.length - 1)
			{
				priceText.text = NumberUtil.formatNumber(carData.price[level + (isUnlocked ? 1 : 0)]);
			}
			else
			{
				title.text = "MAX";
				overScale = 1;
				alpha = 1;
				if (priceContainer != null)
				{
					container.remove(priceContainer);
					priceContainer.destroy();
					priceContainer = null;
				}
			}

			container.rePosition();
			container.x = x + width / 2 - container.width / 2;
		}
	}
}