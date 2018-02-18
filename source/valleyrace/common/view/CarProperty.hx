package valleyrace.common.view;

import flash.display.BitmapData;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPHUIBox;
import valleyrace.assets.Fonts;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarProperty extends HPPHUIBox
{
	public function new(labelText:String, value:Float, minValue:Float, maxValue:Float, invertedProperty:Bool = false)
	{
		super(5);

		var label:FlxText = new FlxText(0, 0, 0, labelText, 20);
		label.color = FlxColor.WHITE;
		label.alignment = "left";
		label.font = Fonts.HOLLYWOOD;
		add(label);

		var maxLineWidth:Float = 80;
		var ratio:Float = (value - minValue) / (maxValue - minValue);
		ratio = invertedProperty ? 1 - ratio : ratio;
		ratio = Math.max(ratio, .1);

		var progress:FlxSprite = new FlxSprite();
		var progressGraphic:Sprite = new Sprite();
		progressGraphic.graphics.beginFill(0x0, .5);
		progressGraphic.graphics.drawRect(0, 0, maxLineWidth, 14);
		progressGraphic.graphics.endFill();
		progressGraphic.graphics.beginFill(0xFFBC11);
		progressGraphic.graphics.drawRect(0, 0, maxLineWidth * ratio, 14);
		progressGraphic.graphics.endFill();
		var progressBitmapData:BitmapData = new BitmapData(cast maxLineWidth, cast progressGraphic.height);
		progressBitmapData.draw(progressGraphic);
		progress.loadGraphic(progressBitmapData);
		add(progress);
	}
}