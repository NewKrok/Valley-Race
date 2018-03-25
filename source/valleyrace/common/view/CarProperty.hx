package valleyrace.common.view;

import flash.display.BitmapData;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.Sprite;
import valleyrace.assets.Fonts;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CarProperty extends FlxSpriteGroup
{
	var progress:FlxSprite;

	var isUnlocked:Bool;
	var level:UInt;
	var values:Array<Float>;
	var minValue:Float;
	var maxValue:Float;
	var invertedProperty:Bool;

	public function new(labelText:String, isUnlocked:Bool, level:UInt, values:Array<Float>, minValue:Float, maxValue:Float, invertedProperty:Bool = false)
	{
		super(5);

		this.isUnlocked = isUnlocked;
		this.level = level;
		this.values = values;
		this.minValue = minValue;
		this.maxValue = maxValue;
		this.invertedProperty = invertedProperty;

		var label:FlxText = new FlxText(0, 0, 70, labelText, 20);
		label.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		label.color = FlxColor.WHITE;
		label.alignment = "right";
		label.font = Fonts.HOLLYWOOD;
		label.y = -2;
		add(label);

		progress = new FlxSprite();
		progress.x = 76;
		add(progress);

		drawProp();
	}

	public function updateView(isUnlocked:Bool, level:UInt):Void
	{
		if (this.level != level || this.isUnlocked != isUnlocked)
		{
			this.isUnlocked = isUnlocked;
			this.level = level;
			drawProp();
		}
	}

	override function get_width():Float
	{
		return 156;
	}

	override function get_height():Float
	{
		return 15;
	}

	function drawProp():Void
	{
		var maxLevel:UInt = values.length - 1;
		var maxLineWidth:Float = 80;
		var actualRatio:Float = (values[level] - minValue) / (maxValue - minValue);
		actualRatio = invertedProperty ? 1 - actualRatio : actualRatio;
		actualRatio = Math.max(actualRatio, .05);

		var nextRatio:Float = level != maxLevel ? (values[level + 1] - minValue) / (maxValue - minValue) : 1;
		nextRatio = invertedProperty ? 1 - nextRatio : nextRatio;
		nextRatio = Math.max(nextRatio, .05);

		var maxRatio:Float = (values[maxLevel] - minValue) / (maxValue - minValue);
		maxRatio = invertedProperty ? 1 - maxRatio : maxRatio;
		maxRatio = Math.max(maxRatio, .05);

		var progressGraphic:Sprite = new Sprite();

		progressGraphic.graphics.beginFill(0x0);
		progressGraphic.graphics.drawRect(0, 0, maxLineWidth, 14);
		progressGraphic.graphics.endFill();

		progressGraphic.graphics.beginFill(0x0E2917);
		progressGraphic.graphics.drawRect(0, 0, maxLineWidth * maxRatio, 14);
		progressGraphic.graphics.endFill();

		if (isUnlocked && level != maxLevel)
		{
			progressGraphic.graphics.beginFill(0x755500);
			progressGraphic.graphics.drawRect(0, 0, maxLineWidth * nextRatio, 14);
			progressGraphic.graphics.endFill();
		}

		progressGraphic.graphics.beginFill(0xFFBC11);
		progressGraphic.graphics.drawRect(0, 0, maxLineWidth * actualRatio, 14);
		progressGraphic.graphics.endFill();

		var progressBitmapData:BitmapData = new BitmapData(cast maxLineWidth, cast progressGraphic.height);
		progressBitmapData.draw(progressGraphic);
		progress.loadGraphic(progressBitmapData);
	}
}