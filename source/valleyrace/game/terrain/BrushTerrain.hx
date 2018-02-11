package valleyrace.game.terrain;

import flash.geom.Matrix;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BrushTerrain extends FlxSpriteGroup
{
	var linePointsInput:Array<BrushArea> = [];
	var linePoints:Array<BrushArea>;

	var vertices:Array<Float>;
	var indices:Array<Int>;
	var uvtData:Array<Float>;
	var lastLength:Float = 0;
	var segLength:Float = 0;
	var groundBaseXOffset:Float;

	public function new (levelSize:Rectangle, groundPoints:Array<FlxPoint>, brushTexture:FlxGraphic, terrainContentTexture:FlxGraphic, textureMaxWidth:Float, textureHeight:Float, groundBaseHeight:Float = 700)
	{
		super();

		groundBaseXOffset = groundPoints[0].x < 0 ? -groundPoints[0].x : 0;
		groundPoints = optimizeGroundPointsToGraphics(groundPoints, brushTexture.width, textureMaxWidth);
		BrushArea.lw = textureHeight;

		var graphicContainer:Sprite = new Sprite();
		graphicContainer.graphics.beginBitmapFill(terrainContentTexture.bitmap);

		for (point in groundPoints)
		{
			graphicContainer.graphics.lineTo(point.x, point.y);
		}

		var brushArea:BrushArea;
		var index:Int = cast groundPoints.length - 1;

		for (i in 0...cast groundPoints.length)
		{
			graphicContainer.graphics.lineTo(groundPoints[index].x, groundPoints[index].y + groundBaseHeight);

			if (i == 0)
			{
				brushArea = new BrushArea(groundPoints[i].x, groundPoints[i].y);
				linePointsInput.push(brushArea);
			}
			else
			{
				brushArea = new BrushArea(groundPoints[i].x, groundPoints[i].y, linePointsInput[linePointsInput.length - 1]);
				linePointsInput.push(brushArea);
			}
			if (i == groundPoints.length - 2)
			{
				brushArea = new BrushArea(groundPoints[i + 1].x, groundPoints[i + 1].y, linePointsInput[linePointsInput.length - 1]);
				linePointsInput.push(brushArea);
			}

			index--;
		}
		graphicContainer.graphics.endFill();

		calculateGraphicTriangles();

		var brushBitmapData = new BitmapData(cast brushTexture.bitmap.width, cast brushTexture.bitmap.height, true, 0x60);
		brushBitmapData.draw(brushTexture.bitmap);
		renderTriangles(graphicContainer, brushBitmapData);

		var graphicBitmap:BitmapData = new BitmapData(cast levelSize.width, cast levelSize.height, true, 0x60);
		graphicBitmap.draw(graphicContainer);

		var maxBlockSize:UInt = 2048;
		var pieces:UInt = Math.ceil(graphicContainer.width / maxBlockSize);
		for (i in 0...pieces)
		{
			var tmpBitmapData:BitmapData = new BitmapData(maxBlockSize, maxBlockSize, true, 0x60);
			var offsetMatrix:Matrix = new Matrix();
			offsetMatrix.tx = -i * maxBlockSize;
			tmpBitmapData.draw(graphicContainer, offsetMatrix);

			var container:FlxSprite = new FlxSprite();
			container.loadGraphic(tmpBitmapData);
			container.x = i * maxBlockSize;
			add(container);
		}
	}

	function optimizeGroundPointsToGraphics(groundPoints:Array<FlxPoint>, textureWidth:Float, textureMaxWidth:Float):Array<FlxPoint>
	{
		var result:Array<FlxPoint> = [];

		var index:UInt = 0;
		for (i in 0...groundPoints.length - 1)
		{
			var lineLength:Float = groundPoints[i + 1].distanceTo(groundPoints[i]);

			if (lineLength < textureMaxWidth)
			{
				result.push(groundPoints[i]);
			}
			else
			{
				var angle:Float = Math.atan2(groundPoints[i + 1].y - groundPoints[i].y, groundPoints[i + 1].x - groundPoints[i].x);
				var pieces:UInt = Math.ceil(lineLength / (textureWidth < textureMaxWidth ? textureWidth : textureMaxWidth));
				var blockSize = lineLength / pieces;

				for (j in 0...pieces)
				{
					var newPoint:FlxPoint = new FlxPoint(
						groundPoints[i].x + blockSize * j * Math.cos(angle),
						groundPoints[i].y + blockSize * j * Math.sin(angle)
					);

					result.push(newPoint);
				}
			}
		}

		return result;
	}

	function calculateGraphicTriangles():Void
	{
		segLength = 1;
		lastLength = 0;
		linePoints = [];
		linePoints.push (linePointsInput[0]);
		vertices = [];
		indices = [];
		uvtData = [];
		var lp:BrushArea;

		for (i in 1...linePointsInput.length)
		{
			lp = linePointsInput[i];
			if (lp.currentLength > lastLength + segLength)
			{
				lastLength = lp.currentLength;
				linePoints.push (lp);
			}
		}
		var count = 0;

		var index:Int = 0;
		for (i in 0...cast linePoints.length / 2 - 1)
		{
			lp = linePoints[index];
			vertices = vertices.concat([lp.xL + groundBaseXOffset, lp.yL, lp.xR + groundBaseXOffset, lp.yR]);

			if (index == linePoints.length - 1)
			{
				lp = linePoints[index];
			}
			else
			{
				lp = linePoints[index + 1];
			}

			vertices = vertices.concat([lp.xL + groundBaseXOffset, lp.yL, lp.xR + groundBaseXOffset, lp.yR]);
			indices = indices.concat([count, count + 1, count + 2, count + 1, count + 2, count + 3]);
			indices = indices.concat([count + 2, count + 3, count + 4, count + 3, count + 4, count + 5]);
			uvtData = uvtData.concat([0, 0, 0, 1, .5, 0, .5, 1]);

			count += 4;
			index += 2;
		}
	}

	function renderTriangles(graphicContainer:Sprite, brushTexture:BitmapData):Void
	{
		graphicContainer.graphics.beginBitmapFill(brushTexture, null, true, true);
		graphicContainer.graphics.drawTriangles(vertices, indices, uvtData);
		graphicContainer.graphics.endFill();
	}
}