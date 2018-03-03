package valleyrace.datatype;

import flixel.math.FlxPoint;
import hpp.util.GeomUtil.SimplePoint;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Krisztian Somoracz
 */
typedef LevelData =
{
	var worldId(default, default):UInt;
	var levelId(default, default):UInt;
	var cameraBounds(default, default):Rectangle;
	var startPoint(default, default):FlxPoint;
	var finishPoint(default, default):FlxPoint;
	var polygonGroundData(default, default):Array<Array<Array<PolygonBackgroundData>>>; // Background with physics
	var polygonBackgroundData(default, default):Array<Array<Array<PolygonBackgroundData>>>; // Simple background
	var collectableItems(default, default):Array<FlxPoint>;
	var starValues(default, default):Array<UInt>;

	//@:optional var libraryElements(default, default):String;
	//@:optional var rectangleBackgroundData(default, default):String;

	@:optional var staticElementData(default, default):Array<StaticElement>;
	@:optional var replay(default, default):String;
	@:optional var bridgePoints(default, default):Array<BridgeData>;
	@:optional var libraryElements(default, default):Array<LibraryElement>;
}

typedef PolygonBackgroundData =
{
	var polygon:Array<FlxPoint>;
	var terrainTextureId:String;
	var usedWorldBlocks:Array<SimplePoint>;
}

typedef BridgeData =
{
	var bridgeAX:Float;
	var bridgeAY:Float;
	var bridgeBX:Float;
	var bridgeBY:Float;
}

typedef StaticElement =
{
	var position:SimplePoint;
	var pivotX:Float;
	var pivotY:Float;
	var scaleX:Float;
	var scaleY:Float;
	var rotation:Float;
	var elementId:String;
}

typedef LibraryElement =
{
	var x:Float;
	var y:Float;
	var className:String;
	var scale:Float;
}