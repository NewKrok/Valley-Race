package valleyrace.common.view;

import hpp.flixel.ui.HPPVUIBox;
import hpp.flixel.ui.PlaceHolder;
import hpp.ui.HAlign;
import valleyrace.assets.CarDatas;
import valleyrace.common.view.CarProperty;
import valleyrace.datatype.CarData;
import valleyrace.menu.view.UpgradeButton;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarDetails extends HPPVUIBox
{
	var upgradeButton:UpgradeButton;
	var elasticityProp:CarProperty;
	var rotationProp:CarProperty;
	var speedProp:CarProperty;

	public function new(upgradeRequest:Void->Void, carData:CarData, isUnlocked:Bool, level:UInt)
	{
		super(5, HAlign.RIGHT);

		add(new PlaceHolder(1, 3));
		add(speedProp = new CarProperty("SPEED", isUnlocked, level, carData.speed, CarDatas.MIN_SPEED, CarDatas.MAX_SPEED));
		add(rotationProp = new CarProperty("HANDLING", isUnlocked, level, carData.rotation, CarDatas.MIN_ROTATION, CarDatas.MAX_ROTATION));
		add(elasticityProp = new CarProperty("WHEEL", isUnlocked, level, carData.elasticity, CarDatas.MAX_ELASTICITY, CarDatas.MIN_ELASTICITY, true));
		add(upgradeButton = new UpgradeButton(upgradeRequest, isUnlocked, level, carData));
	}

	public function updateView(isUnlocked:Bool, level:UInt):Void
	{
		speedProp.updateView(isUnlocked, level);
		rotationProp.updateView(isUnlocked, level);
		elasticityProp.updateView(isUnlocked, level);
		upgradeButton.updateView(isUnlocked, level);
	}
}