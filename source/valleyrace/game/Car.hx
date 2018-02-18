package valleyrace.game;

import apostx.replaykit.IRecorderPerformer;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import haxe.Serializer;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.geom.Point;
import valleyrace.assets.CarDatas;
import valleyrace.datatype.CarData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Car extends AbstractCar implements IRecorderPerformer
{
	var carLeveledData:CarLeveledData;

	var wheelJoinDamping:Float = .3;
	var wheelJoinHertz:Float = 3;

	var firstWheelXOffset:Float = 55;
	var firstWheelYOffset:Float = 35;
	var firstWheelRadius:Float = 40;
	var backWheelXOffset:Float = -52;
	var backWheelYOffset:Float = 35;
	var backWheelRadius:Float = 40;
	var bodyWidth:Float = 150;
	var bodyHeight:Float = 45;
	var hitAreaHeight:Float = 10;

	var hitArea:Body;
	public var carBodyPhysics:Body;
	public var wheelRightPhysics:Body;
	public var wheelLeftPhysics:Body;

	public var isOnWheelie:Bool;
	public var onWheelieStartGameTime:Float;

	public var isOnAir:Bool;
	public var onAirStartGameTime:Float;
	public var jumpAngle:Float = 0;
	public var lastAngleOnGround:Float = 0;

	public var leftWheelOnAir(default, null):Bool;
	public var rightWheelOnAir(default, null):Bool;
	public var isCarCrashed(default, null):Bool;

	var direction:Int = 1;
	var space:Space;

	public function new(space:Space, x:Float, y:Float, carData:CarData, scale:Float = 1, filterCategory:UInt = 0, filterMask:UInt = 0)
	{
		super(carData, scale);
		carLeveledData = CarDatas.getLeveledData(carData.id);

		this.space = space;

		firstWheelXOffset += Math.isNaN(carData.firstWheelXOffset) ? 0 : carData.firstWheelXOffset;
		firstWheelYOffset += Math.isNaN(carData.firstWheelYOffset) ? 0 : carData.firstWheelYOffset;
		backWheelXOffset += Math.isNaN(carData.backWheelXOffset) ? 0 : carData.backWheelXOffset;
		backWheelYOffset += Math.isNaN(carData.backWheelYOffset) ? 0 : carData.backWheelYOffset;

		firstWheelXOffset *= scale;
		firstWheelYOffset *= scale;
		firstWheelRadius *= scale;
		backWheelXOffset *= scale;
		backWheelYOffset *= scale;
		backWheelRadius *= scale;
		bodyWidth *= scale;
		bodyHeight *= scale;
		hitAreaHeight *= scale;

		buildPhysics(x, y, filterCategory, filterMask);
	}

	function buildPhysics(x:Float, y:Float, filterCategory:Int = 0, filterMask:Int = 0):Void
	{
		var filter:InteractionFilter = new InteractionFilter();
		filter.collisionGroup = filterCategory;
		filter.collisionMask = filterMask;

		wheelRightPhysics = new Body();
		wheelRightPhysics.shapes.add(new Circle(firstWheelRadius));
		wheelRightPhysics.setShapeFilters(filter);
		wheelRightPhysics.position.x = x + firstWheelXOffset;
		wheelRightPhysics.position.y = y + firstWheelYOffset;
		wheelRightPhysics.space = space;
		wheelRightPhysics.mass = 1;

		wheelLeftPhysics = new Body();
		wheelLeftPhysics.shapes.add(new Circle(firstWheelRadius));
		wheelLeftPhysics.setShapeFilters(filter);
		wheelLeftPhysics.position.x = x + backWheelXOffset;
		wheelLeftPhysics.position.y = y + backWheelYOffset;
		wheelLeftPhysics.space = space;
		wheelRightPhysics.mass = 1;

		carBodyPhysics = new Body();
		carBodyPhysics.shapes.add(new Polygon(Polygon.box(bodyWidth, bodyHeight)));
		carBodyPhysics.setShapeFilters(filter);
		carBodyPhysics.position.x = x;
		carBodyPhysics.position.y = y;
		carBodyPhysics.space = space;
		carBodyPhysics.mass = 1;

		hitArea = new Body();
		hitArea.shapes.add(new Polygon(Polygon.box(bodyWidth * .7, hitAreaHeight)));
		hitArea.setShapeFilters(filter);
		hitArea.space = space;
		hitArea.mass = 1;

		var hitAreaAnchor:Vec2 = new Vec2(0, bodyHeight / 2 + hitAreaHeight / 2);
		var hitJoin:WeldJoint = new WeldJoint(carBodyPhysics, hitArea, carBodyPhysics.localCOM, hitAreaAnchor);
		hitJoin.space = space;

		var bodyLeftAnchor:Vec2 = new Vec2(backWheelXOffset, backWheelYOffset);
		var pivotJointLeftLeftWheel:PivotJoint = new PivotJoint(wheelLeftPhysics, carBodyPhysics, wheelLeftPhysics.localCOM, bodyLeftAnchor);
		pivotJointLeftLeftWheel.stiff = false;
		pivotJointLeftLeftWheel.damping = wheelJoinDamping;
		pivotJointLeftLeftWheel.frequency = wheelJoinHertz;
		pivotJointLeftLeftWheel.space = space;

		var bodyRightAnchor:Vec2 = new Vec2(firstWheelXOffset, firstWheelYOffset);
		var pivotJointRightRightWheel:PivotJoint = new PivotJoint(wheelRightPhysics, carBodyPhysics, wheelRightPhysics.localCOM, bodyRightAnchor);
		pivotJointRightRightWheel.stiff = false;
		pivotJointRightRightWheel.damping = wheelJoinDamping;
		pivotJointRightRightWheel.frequency = wheelJoinHertz;
		pivotJointRightRightWheel.space = space;

		var distance:Float = firstWheelXOffset + Math.abs(backWheelXOffset);
		var wheelJoin:DistanceJoint = new DistanceJoint(wheelRightPhysics, wheelLeftPhysics, wheelRightPhysics.localCOM, wheelLeftPhysics.localCOM, distance, distance);
		wheelJoin.space = space;
	}

	public function getMidXPosition():Float
	{
		return carBodyGraphics.x;
	}

	public function getMidYPosition():Float
	{
		return carBodyGraphics.y;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		carBodyGraphics.x = carBodyPhysics.position.x - carBodyGraphics.origin.x;
		carBodyGraphics.y = carBodyPhysics.position.y - carBodyGraphics.origin.y;
		carBodyGraphics.angle = carBodyPhysics.rotation * FlxAngle.TO_DEG;

		wheelRightGraphics.x = wheelRightPhysics.position.x - wheelRightGraphics.origin.x;
		wheelRightGraphics.y = wheelRightPhysics.position.y - wheelRightGraphics.origin.y;
		wheelRightGraphics.angle = wheelRightPhysics.rotation * FlxAngle.TO_DEG;

		wheelLeftGraphics.x = wheelLeftPhysics.position.x - wheelLeftGraphics.origin.x;
		wheelLeftGraphics.y = wheelLeftPhysics.position.y - wheelLeftGraphics.origin.y;
		wheelLeftGraphics.angle = wheelLeftPhysics.rotation * FlxAngle.TO_DEG;

		frontSpring.x = carBodyPhysics.position.x + frontSpring.origin.x + 77 * Math.cos(carBodyGraphics.angle * (Math.PI / 180)) + 1 * Math.cos((carBodyGraphics.angle + 90) * (Math.PI / 180));
		frontSpring.y = carBodyPhysics.position.y + frontSpring.origin.y + 77 * Math.sin(carBodyGraphics.angle * (Math.PI / 180)) + 1 * Math.sin((carBodyGraphics.angle + 90) * (Math.PI / 180));
		frontSpring.scale.x = Point.distance(
			new Point(wheelRightGraphics.x + wheelRightGraphics.origin.x, wheelRightGraphics.y + wheelRightGraphics.origin.y),
			new Point(frontSpring.x, frontSpring.y)
		) / 59;
		frontSpring.angle = Math.atan2(wheelRightGraphics.y + wheelRightGraphics.origin.y - frontSpring.y, wheelRightGraphics.x + wheelRightGraphics.origin.x - frontSpring.x) * (180 / Math.PI);

		backSpring.x = carBodyPhysics.position.x + backSpring.origin.x - 32 * Math.cos(carBodyGraphics.angle * (Math.PI / 180)) + 14 * Math.cos((carBodyGraphics.angle + 90) * (Math.PI / 180));
		backSpring.y = carBodyPhysics.position.y + backSpring.origin.y - 32 * Math.sin(carBodyGraphics.angle * (Math.PI / 180)) + 14 * Math.sin((carBodyGraphics.angle + 90) * (Math.PI / 180));
		backSpring.scale.x = Point.distance(
			new Point(wheelLeftGraphics.x + wheelLeftGraphics.origin.x, wheelLeftGraphics.y + wheelLeftGraphics.origin.y),
			new Point(backSpring.x, backSpring.y)
		) / 59;
		backSpring.angle = Math.atan2(wheelLeftGraphics.y + wheelLeftGraphics.origin.y - backSpring.y, wheelLeftGraphics.x + wheelLeftGraphics.origin.x - backSpring.x) * (180 / Math.PI);

		wheelBackTopHolderGraphics.x = carBodyPhysics.position.x + wheelBackTopHolderGraphics.origin.x + 8 * Math.cos(carBodyGraphics.angle * (Math.PI / 180)) + 45 * Math.cos((carBodyGraphics.angle + 90) * (Math.PI / 180));
		wheelBackTopHolderGraphics.y = carBodyPhysics.position.y + wheelBackTopHolderGraphics.origin.y + 8 * Math.sin(carBodyGraphics.angle * (Math.PI / 180)) + 45 * Math.sin((carBodyGraphics.angle + 90) * (Math.PI / 180));
		wheelBackTopHolderGraphics.angle = Math.atan2(wheelLeftGraphics.y + wheelLeftGraphics.origin.y - wheelBackTopHolderGraphics.y, wheelLeftGraphics.x + wheelLeftGraphics.origin.x - wheelBackTopHolderGraphics.x) * (180 / Math.PI);

		wheelBackBottomHolderGraphics.x = carBodyPhysics.position.x + wheelBackBottomHolderGraphics.origin.x + 6 * Math.cos(carBodyGraphics.angle * (Math.PI / 180)) + 62 * Math.cos((carBodyGraphics.angle + 90) * (Math.PI / 180));
		wheelBackBottomHolderGraphics.y = carBodyPhysics.position.y + wheelBackBottomHolderGraphics.origin.y + 6 * Math.sin(carBodyGraphics.angle * (Math.PI / 180)) + 62 * Math.sin((carBodyGraphics.angle + 90) * (Math.PI / 180));
		wheelBackBottomHolderGraphics.angle = Math.atan2(wheelLeftGraphics.y + wheelLeftGraphics.origin.y - wheelBackBottomHolderGraphics.y, wheelLeftGraphics.x + wheelLeftGraphics.origin.x - wheelBackBottomHolderGraphics.x) * (180 / Math.PI);

		wheelFrontTopHolderGraphics.x = carBodyPhysics.position.x + wheelFrontTopHolderGraphics.origin.x + 28 * Math.cos(carBodyGraphics.angle * (Math.PI / 180)) + 35 * Math.cos((carBodyGraphics.angle + 90) * (Math.PI / 180));
		wheelFrontTopHolderGraphics.y = carBodyPhysics.position.y + wheelFrontTopHolderGraphics.origin.y + 28 * Math.sin(carBodyGraphics.angle * (Math.PI / 180)) + 35 * Math.sin((carBodyGraphics.angle + 90) * (Math.PI / 180));
		wheelFrontTopHolderGraphics.angle = Math.atan2(wheelRightGraphics.y + wheelRightGraphics.origin.y - wheelFrontTopHolderGraphics.y, wheelRightGraphics.x + wheelRightGraphics.origin.x - wheelFrontTopHolderGraphics.x) * (180 / Math.PI);

		wheelFrontBottomHolderGraphics.x = carBodyPhysics.position.x + wheelFrontBottomHolderGraphics.origin.x + 26 * Math.cos(carBodyGraphics.angle * (Math.PI / 180)) + 52 * Math.cos((carBodyGraphics.angle + 90) * (Math.PI / 180));
		wheelFrontBottomHolderGraphics.y = carBodyPhysics.position.y + wheelFrontBottomHolderGraphics.origin.y + 26 * Math.sin(carBodyGraphics.angle * (Math.PI / 180)) + 52 * Math.sin((carBodyGraphics.angle + 90) * (Math.PI / 180));
		wheelFrontBottomHolderGraphics.angle = Math.atan2(wheelRightGraphics.y + wheelRightGraphics.origin.y - wheelFrontBottomHolderGraphics.y, wheelRightGraphics.x + wheelRightGraphics.origin.x - wheelFrontBottomHolderGraphics.x) * (180 / Math.PI);

		calculateCollision();
	}

	function calculateCollision():Void
	{
		var contactList:BodyList = wheelLeftPhysics.interactingBodies();
		leftWheelOnAir = true;

		while (!contactList.empty())
		{
			var obj:Body = contactList.pop();
			if (obj != carBodyPhysics)
			{
				leftWheelOnAir = false;
				break;
			}
		}

		contactList = wheelRightPhysics.interactingBodies();
		rightWheelOnAir = true;

		while (!contactList.empty())
		{
			var obj:Body = contactList.pop();
			if (obj != carBodyPhysics)
			{
				rightWheelOnAir = false;
				break;
			}
		}

		contactList = hitArea.interactingBodies(InteractionType.COLLISION, 1);
		isCarCrashed = false;

		while (!contactList.empty())
		{
			var obj:Body = contactList.pop();
			if (obj != carBodyPhysics && obj != wheelLeftPhysics && obj != wheelRightPhysics)
			{
				isCarCrashed = true;
				break;
			}
		}
	}

	public function accelerateToLeft():Void
	{
		direction = -1;

		wheelLeftPhysics.angularVel = -carLeveledData.speed / 2;
		wheelRightPhysics.angularVel = -carLeveledData.speed / 2;
	}

	public function accelerateToRight():Void
	{
		direction = 1;

		wheelLeftPhysics.angularVel = carLeveledData.speed;
		wheelRightPhysics.angularVel = carLeveledData.speed;
	}

	public function rotateLeft():Void
	{
		carBodyPhysics.applyAngularImpulse(-carLeveledData.rotation);
	}

	public function rotateRight():Void
	{
		carBodyPhysics.applyAngularImpulse(carLeveledData.rotation);
	}

	public function teleportTo(x:Float, y:Float):Void
	{
		carBodyPhysics.position.x = x;
		carBodyPhysics.position.y = y;
		carBodyPhysics.rotation = 0;
		carBodyPhysics.velocity.setxy(0, 0);
		carBodyPhysics.angularVel = 0;

		wheelRightPhysics.position.x = x + firstWheelXOffset;
		wheelRightPhysics.position.y = y + firstWheelYOffset;
		wheelRightPhysics.rotation = 0;
		wheelRightPhysics.velocity.setxy(0, 0);
		wheelRightPhysics.angularVel = 0;

		wheelLeftPhysics.position.x = x + backWheelXOffset;
		wheelLeftPhysics.position.y = y + backWheelYOffset;
		wheelLeftPhysics.rotation = 0;
		wheelLeftPhysics.velocity.setxy(0, 0);
		wheelLeftPhysics.angularVel = 0;

		hitArea.position.x = x;
		hitArea.position.y = y + bodyHeight / 2 + hitAreaHeight / 2;
		hitArea.rotation = 0;
		hitArea.velocity.setxy(0, 0);
		hitArea.angularVel = 0;

		update(0);
	}

	public function serialize(s:Serializer):Void
	{
		serializeSprite(s, carBodyGraphics);
		serializeSprite(s, wheelRightGraphics);
		serializeSprite(s, wheelLeftGraphics);
	}

	private function serializeSprite(s:Serializer, sprite:FlxSprite):Void
	{
		s.serialize(sprite.x);
		s.serialize(sprite.y);
		s.serialize(sprite.angle);
	}
}