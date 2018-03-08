package valleyrace.menu.view;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.CarDatas;
import valleyrace.common.view.CarDetails;
import valleyrace.datatype.CarData;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarPreview extends FlxSpriteGroup
{
	public var isSelected(default, set):Bool;
	public var id:UInt;
	public var isUnlocked:Bool;

	var background:FlxSprite;
	var carDetails:CarDetails;
	var carData:CarData;
	var onCarUpgrade:Void->Void;

	public function new(onSelect:CarPreview->Void, onCarUpgrade:Void->Void, id:UInt, isSelected:Bool)
	{
		super();

		var button = new HPPButton("", function(_) { onSelect(this); }, "car_preview_back");
		button.alpha = 0;

		this.onCarUpgrade = onCarUpgrade;
		this.id = id;

		add(background = new FlxSprite());
		this.isSelected = isSelected;

		var baseContainer:HPPHUIBox = new HPPHUIBox(5);

		var savedCarData = SavedDataUtil.getPlayerInfo().carDatas[id];
		carData = CarDatas.getData(id);
		baseContainer.add(HPPAssetManager.getSprite("car_preview_" + id));
		baseContainer.add(carDetails = new CarDetails(upgradeRequest, carData, savedCarData.isUnlocked, savedCarData.level));
		isUnlocked = savedCarData.isUnlocked;

		baseContainer.x = width / 2 - baseContainer.width / 2;
		baseContainer.y = height / 2 - baseContainer.height / 2;
		add(baseContainer);
		add(button);
	}

	function upgradeRequest()
	{
		var playerInfo = SavedDataUtil.getPlayerInfo();
		var savedCarData = playerInfo.carDatas[id];

		playerInfo.coin -= carData.price[savedCarData.level + 1];
		savedCarData.level++;

		SavedDataUtil.save();

		if (!savedCarData.isUnlocked)
			savedCarData.isUnlocked = true;

		isUnlocked = savedCarData.isUnlocked;

		onCarUpgrade();
	}

	public function updateView():Void
	{
		var savedCarData = SavedDataUtil.getPlayerInfo().carDatas[id];

		carDetails.updateView(savedCarData.isUnlocked, savedCarData.level);
	}

	function set_isSelected(value:Bool):Bool
	{
		background.loadGraphic(
			value
				? HPPAssetManager.getGraphic("car_preview_back_selected")
				: HPPAssetManager.getGraphic("car_preview_back")
		);

		return isSelected = value;
	}
}