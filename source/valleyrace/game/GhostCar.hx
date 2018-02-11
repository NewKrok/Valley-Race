package valleyrace.game;

import apostx.replaykit.IPlaybackPerformer;
import flixel.FlxSprite;
import haxe.Unserializer;
import valleyrace.datatype.CarData;

class GhostCar extends AbstractCar implements IPlaybackPerformer
{
	public function new(carData:CarData, scale:Float = 1)
	{
		super(carData, scale);
	}

	public function unserializeWithTransition(from:Unserializer, to:Unserializer, percent:Float):Void
	{
		unserializeSprite(from, to, percent, carBodyGraphics);
		unserializeSprite(from, to, percent, wheelRightGraphics);
		unserializeSprite(from, to, percent, wheelLeftGraphics);
	}

	private function unserializeSprite(from:Unserializer, to:Unserializer, percent:Float, sprite:FlxSprite):Void
	{
		sprite.x = calculateLinearTransitionValue(from.unserialize(), to.unserialize(), percent);
		sprite.y = calculateLinearTransitionValue(from.unserialize(), to.unserialize(), percent);
		sprite.angle = calculateLinearTransitionValue(from.unserialize(), to.unserialize(), percent);
	}

	private function calculateLinearTransitionValue(from:Float, to:Float, percent:Float):Float
	{
		return from + (to - from) * percent;
	}
}