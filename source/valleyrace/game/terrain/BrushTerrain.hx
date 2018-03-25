package valleyrace.game.terrain;

import flash.geom.Matrix;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import hpp.flixel.util.HPPAssetManager;
import hpp.util.GeomUtil.SimplePoint;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import valleyrace.config.TextureConfig;
import valleyrace.datatype.LevelData.PolygonBackgroundData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BrushTerrain extends FlxSpriteGroup
{
	var linePointsInput:Array<BrushArea> = [];
	var linePoints:Array<BrushArea>;
	var elements:Array<FlxSprite> = [];

	var vertices:Array<Float>;
	var indices:Array<Int>;
	var uvtData:Array<Float>;
	var lastLength:Float = 0;
	var segLength:Float = 0;
	var groundBaseXOffset:Float = 0;
	var groundBaseYOffset:Float = 0;

	public function new (row:UInt, col:UInt, size:SimplePoint, polygonBackgroundDatas:Array<PolygonBackgroundData>, textureMaxWidth:Float, textureHeight:Float)
	{
		super();

		var graphicContainer:Sprite = new Sprite();
		var usedWorldBlocks:Array<SimplePoint> = [];

		for (polygonBackgroundData in polygonBackgroundDatas)
		{
			usedWorldBlocks = usedWorldBlocks.concat(polygonBackgroundData.usedWorldBlocks);

			var brushTexture = TextureConfig.getPolygonTerrainGroundGraphic(polygonBackgroundData.terrainTextureId) == ""
				? null
				: HPPAssetManager.getGraphic(TextureConfig.getPolygonTerrainGroundGraphic(polygonBackgroundData.terrainTextureId));

			var terrainContentTexture = HPPAssetManager.getGraphic(TextureConfig.getPolygonTerrainFillGraphic(polygonBackgroundData.terrainTextureId));

			var groundPoints:Array<FlxPoint> = [];
			for (point in polygonBackgroundData.polygon)
				groundPoints.push(new FlxPoint(point.x, point.y));

			graphicContainer.graphics.beginBitmapFill(terrainContentTexture.bitmap);

			// To fix start graphic
			groundPoints.push(groundPoints[0].copyTo());
			groundPoints.push(groundPoints[1].copyTo());
			groundPoints.push(groundPoints[2].copyTo());

			groundBaseXOffset = groundPoints[0].x < 0 ? -groundPoints[0].x : 0;
			groundBaseYOffset = groundPoints[0].y < 0 ? -groundPoints[0].y : 0;

			if (brushTexture != null) groundPoints = optimizeGroundPointsToGraphics(groundPoints, brushTexture.width, textureMaxWidth);
			BrushArea.lw = textureHeight;

			var brushArea:BrushArea;

			for (i in 0...groundPoints.length)
			{
				if (i == 0)
				{
					if (brushTexture != null)
					{
						brushArea = new BrushArea(groundPoints[i].x, groundPoints[i].y);
						linePointsInput.push(brushArea);
					}
					graphicContainer.graphics.moveTo(groundPoints[i].x, groundPoints[i].y);
				}
				else
				{
					if (brushTexture != null)
					{
						brushArea = new BrushArea(groundPoints[i].x, groundPoints[i].y, linePointsInput[linePointsInput.length - 1]);
						linePointsInput.push(brushArea);
					}
					graphicContainer.graphics.lineTo(groundPoints[i].x, groundPoints[i].y);
				}

				if (i == groundPoints.length - 3) graphicContainer.graphics.endFill();
			}

			if (brushTexture != null)
			{
				calculateGraphicTriangles();

				var brushBitmapData = new BitmapData(cast brushTexture.bitmap.width, cast brushTexture.bitmap.height, true, 0x60);
				brushBitmapData.draw(brushTexture.bitmap);
				renderTriangles(graphicContainer, brushBitmapData);
			}

			linePointsInput = [];
			linePoints = [];
			vertices = [];
			indices = [];
			uvtData = [];
			lastLength = 0;
			segLength = 0;
		}

		var maxBlockSize:UInt = 512;
		var piecesX:UInt = Math.ceil(size.x / maxBlockSize);
		var piecesY:UInt = Math.ceil(size.y / maxBlockSize);

		for (i in 0...piecesX)
		{
			for (j in 0...piecesY)
			{
				var isUsedBlock:Bool = false;
				for (block in usedWorldBlocks)
				{
					if (
						block.x - (row * Math.floor(AppConfig.WORLD_PIECE_SIZE.x / AppConfig.WORLD_BLOCK_SIZE.x)) == i
						&& block.y - (col * Math.floor(AppConfig.WORLD_PIECE_SIZE.y / AppConfig.WORLD_BLOCK_SIZE.y)) == j
					){
						isUsedBlock = true;
						break;
					}
				}

				if (isUsedBlock)
				{
					var tmpBitmapData:BitmapData = new BitmapData(maxBlockSize, maxBlockSize, true, 0x60);
					var offsetMatrix:Matrix = new Matrix();
					offsetMatrix.tx = -i * maxBlockSize;
					offsetMatrix.ty = -j * maxBlockSize;
					tmpBitmapData.draw(graphicContainer, offsetMatrix);

					var container:FlxSprite = new FlxSprite();
					container.loadGraphic(tmpBitmapData);
					container.x = i * maxBlockSize;
					container.y = j * maxBlockSize;
					add(container);
					elements.push(container);
				}
			}
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

		for (i in 0...linePointsInput.length)
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
		for (i in 0...Math.floor(linePoints.length / 2))
		{
			lp = linePoints[index];
			vertices = vertices.concat([lp.xL + groundBaseXOffset, lp.yL + groundBaseYOffset, lp.xR + groundBaseXOffset, lp.yR + groundBaseYOffset]);

			if (index == linePoints.length - 1)
			{
				lp = linePoints[index];
			}
			else
			{
				lp = linePoints[index + 1];
			}

			vertices = vertices.concat([lp.xL + groundBaseXOffset, lp.yL + groundBaseYOffset, lp.xR + groundBaseXOffset, lp.yR + groundBaseYOffset]);
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

	public function updateView(camPosition:SimplePoint):Void
	{
		for (element in elements) element.visible = Math.abs(camPosition.x - (element.x + element.width / 2)) < 1500;
	}
}