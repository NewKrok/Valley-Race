package valleyrace.game;

import apostx.replaykit.IPlaybackPerformer;
import flixel.FlxSprite;
import haxe.Unserializer;
import valleyrace.datatype.CarData;

class OpponentCar extends AbstractCar implements IPlaybackPerformer
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
		unserializeSprite(from, to, percent, frontSpring);
		unserializeSprite(from, to, percent, backSpring);
		unserializeSprite(from, to, percent, wheelBackTopHolderGraphics);
		unserializeSprite(from, to, percent, wheelBackBottomHolderGraphics);
		unserializeSprite(from, to, percent, wheelFrontTopHolderGraphics);
		unserializeSprite(from, to, percent, wheelFrontBottomHolderGraphics);
	}

	private function unserializeSprite(from:Unserializer, to:Unserializer, percent:Float, sprite:FlxSprite):Void
	{
		sprite.x = calculateLinearTransitionValue(from.unserialize(), to.unserialize(), percent);
		sprite.y = calculateLinearTransitionValue(from.unserialize(), to.unserialize(), percent);

		var fromAngle:Float = from.unserialize();
		while (fromAngle > 360) fromAngle -= 360;
		var toAngle:Float = to.unserialize();
		while (toAngle > 360) toAngle -= 360;
		if (fromAngle - 180 > toAngle) toAngle += 360;
		if (toAngle - 180 > fromAngle) fromAngle += 360;
		var newAngle:Float = calculateLinearTransitionValue(fromAngle, toAngle, percent);
		sprite.angle = newAngle;
	}

	private function calculateLinearTransitionValue(from:Float, to:Float, percent:Float):Float
	{
		return from + (to - from) * percent;
	}
}