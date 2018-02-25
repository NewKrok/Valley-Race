package valleyrace.datatype;

import flixel.math.FlxPoint;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Krisztian Somoracz
 */
typedef LevelData =
{
	var worldId( default, default ):UInt;
	var levelId( default, default ):UInt;
	var cameraBounds( default, default ):Rectangle;
	@:optional var starValues( default, default ):Array<UInt>;
	var startPoint( default, default ):FlxPoint;
	var finishPoint( default, default ):FlxPoint;
	var polygonGroundData( default, default ):Array<PolygonBackgroundData>; // Background with physics
	var polygonBackgroundData( default, default ):Array<PolygonBackgroundData>; // Simple background
	var starPoints( default, default ):Array<FlxPoint>;

	//@:optional var libraryElements( default, default ):String;
	//@:optional var staticElementData( default, default ):String;
	//@:optional var staticElementData( default, default ):String;
	//@:optional var rectangleBackgroundData( default, default ):String;
	@:optional var replay( default, default ):String;
	@:optional var bridgePoints( default, default ):Array<BridgeData>;
	@:optional var gameObjects( default, default ):Array<GameObject>;
	@:optional var libraryElements( default, default ):Array<LibraryElement>;
}

typedef PolygonBackgroundData =
{
	var polygon:Array<FlxPoint>;
	var terrainTextureId:String;
}

typedef BridgeData =
{
	var bridgeAX:Float;
	var bridgeAY:Float;
	var bridgeBX:Float;
	var bridgeBY:Float;
}

typedef GameObject =
{
	var x:Float;
	var y:Float;
	var pivotX:Float;
	var pivotY:Float;
	var scaleX:Float;
	var scaleY:Float;
	var rotation:Float;
	var texture:String;
}

typedef LibraryElement =
{
	var x:Float;
	var y:Float;
	var className:String;
	var scale:Float;
}