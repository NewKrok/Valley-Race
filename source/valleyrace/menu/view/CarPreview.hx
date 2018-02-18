package valleyrace.menu.view;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.assets.CarDatas;
import valleyrace.common.view.CarDetails;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarPreview extends FlxSpriteGroup
{
	public var isSelected(default, set):Bool;
	var background:FlxSprite;

	public function new(id:UInt, isSelected:Bool)
	{
		super();

		add(background = new FlxSprite());
		this.isSelected = isSelected;

		var baseContainer:HPPHUIBox = new HPPHUIBox(5);

		baseContainer.add(HPPAssetManager.getSprite("car_preview_" + id));
		baseContainer.add(new CarDetails(CarDatas.getLeveledData(id)));

		baseContainer.x = width / 2 - baseContainer.width / 2;
		baseContainer.y = height / 2 - baseContainer.height / 2;
		add(baseContainer);
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