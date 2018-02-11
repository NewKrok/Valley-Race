package valleyrace.game.view;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.util.HPPAssetManager;
import hpp.ui.VAlign;
import valleyrace.assets.Fonts;
import valleyrace.common.view.CarDetails;
import valleyrace.datatype.CarData;
import openfl.display.BitmapData;
import openfl.geom.Matrix;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarInfoBlock extends HPPHUIBox
{
	public function new(carData:CarData)
	{
		super(20, VAlign.TOP);

		createCarName(carData.name);
		createCarPreview(carData.graphicId);
		add(new CarDetails(carData));
	}

	function createCarName(carName:String)
	{
		var checkboxLabel:FlxText = new FlxText(0, 0, 0, carName, 21);
		checkboxLabel.color = FlxColor.YELLOW;
		checkboxLabel.alignment = "left";
		checkboxLabel.font = Fonts.HOLLYWOOD;
		checkboxLabel.wordWrap = true;
		checkboxLabel.fieldWidth = 110;
		add(checkboxLabel);
	}

	function createCarPreview(graphicId:UInt):Void
	{
		var preview:FlxSprite = HPPAssetManager.getSprite("car_info_car_" + graphicId);

		var previewScale:Float = .75;
		var scaleMatrix:Matrix = new Matrix();
		scaleMatrix.scale(previewScale, previewScale);
		var previewPic:BitmapData = new BitmapData(cast preview.width * previewScale, cast preview.height * previewScale, true, 0x00);
		previewPic.draw(preview.framePixels, scaleMatrix);

		var container:FlxSprite = new FlxSprite();
		container.loadGraphic(previewPic);

		add(container);
	}
}