package valleyrace.game;

import apostx.replaykit.IRecorderPerformer;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import haxe.Serializer;
import hpp.flixel.util.HPPAssetManager;
import hpp.util.GeomUtil;
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

	var frontSpringHorizontalOffset:Float = 77;
	var frontSpringVerticalOffset:Float = 1;
	var backSpringHorizontalOffset:Float = 32;
	var backSpringVerticalOffset:Float = 14;
	var backTopHolderHorizontalOffset:Float = 8;
	var backTopHolderVerticalOffset:Float = 45;
	var backBottomHolderHorizontalOffset:Float = 6;
	var backBottomHolderVerticalOffset:Float = 62;
	var frontTopHolderHorizontalOffset:Float = 28;
	var frontTopHolderVerticalOffset:Float = 35;
	var frontBottomHolderHorizontalOffset:Float = 26;
	var frontBottomHolderVerticalOffset:Float = 52;

	var flagJoinDamping:Float = .15;
	var flagJoinHertz:Float = 1.5;

	var flagEndPointXOffet:Float = -115;
	var flagEndPointYOffet:Float = -72;
	var flagGraphicXOffset:Float = -55;
	var flagGraphicYOffset:Float = -20;
	var flagAngleOffset:Float = 145;

	var lightBreakGraphicXOffset:Float = -97;
	var lightBreakGraphicYOffset:Float = -17;

	var carAngleCos:Float;
	var carAngleSin:Float;
	var carAngleRotatedCos:Float;
	var carAngleRotatedSin:Float;

	var hitArea:Body;
	public var carBodyPhysics:Body;
	public var wheelRightPhysics:Body;
	public var wheelLeftPhysics:Body;
	public var flagPhysics:Body;

	public var flagGraphic:FlxSprite;
	public var lightBreakeGraphic:FlxSprite;

	public var isOnWheelie:Bool;
	public var onWheelieStartGameTime:Float;

	public var isOnAir:Bool;
	public var onAirStartGameTime:Float;
	public var jumpAngle:Float = 0;
	public var lastAngleOnGround:Float = 0;
	public var isHorizontalMoveDisabled:Bool = false;

	public var leftWheelOnAir(default, null):Bool;
	public var rightWheelOnAir(default, null):Bool;
	public var isCarCrashed(default, null):Bool;

	var direction:Int = 1;
	var space:Space;
	var hasFlag:Bool;

	public function new(space:Space, x:Float, y:Float, carData:CarData, carScale:Float = 1, filterCategory:UInt = 0, filterMask:UInt = 0)
	{
		hasFlag = carData.flagGraphic != null && carData.flagGraphic != "";

		super(carData, carScale);
		carLeveledData = CarDatas.getLeveledData(carData.id);

		this.space = space;

		firstWheelXOffset += Math.isNaN(carData.firstWheelXOffset) ? 0 : carData.firstWheelXOffset;
		firstWheelYOffset += Math.isNaN(carData.firstWheelYOffset) ? 0 : carData.firstWheelYOffset;
		backWheelXOffset += Math.isNaN(carData.backWheelXOffset) ? 0 : carData.backWheelXOffset;
		backWheelYOffset += Math.isNaN(carData.backWheelYOffset) ? 0 : carData.backWheelYOffset;

		firstWheelXOffset *= carScale;
		firstWheelYOffset *= carScale;
		firstWheelRadius *= carScale;
		backWheelXOffset *= carScale;
		backWheelYOffset *= carScale;
		backWheelRadius *= carScale;
		bodyWidth *= carScale;
		bodyHeight *= carScale;
		hitAreaHeight *= carScale;

		frontSpringHorizontalOffset*= carScale;
		frontSpringVerticalOffset *= carScale;
		backSpringHorizontalOffset *= carScale;
		backSpringVerticalOffset *= carScale;
		backTopHolderHorizontalOffset *= carScale;
		backTopHolderVerticalOffset *= carScale;
		backBottomHolderHorizontalOffset *= carScale;
		backBottomHolderVerticalOffset *= carScale;
		frontTopHolderHorizontalOffset *= carScale;
		frontTopHolderVerticalOffset *= carScale;
		frontBottomHolderHorizontalOffset *= carScale;
		frontBottomHolderVerticalOffset *= carScale;

		flagEndPointXOffet *= carScale;
		flagEndPointYOffet *= carScale;

		lightBreakGraphicXOffset *= carScale;
		lightBreakGraphicYOffset *= carScale;

		buildPhysics(x, y, filterCategory, filterMask);
	}

	override function buildGraphics():Void
	{
		if (hasFlag)
		{
			add(flagGraphic = HPPAssetManager.getSprite(carData.flagGraphic));
			flagGraphic.antialiasing = true;
			flagGraphic.scale = new FlxPoint(carScale, carScale);
			flagGraphic.origin.set(flagGraphic.width, flagGraphic.height);
		}

		super.buildGraphics();

		add(lightBreakeGraphic = HPPAssetManager.getSprite("break_light"));
		lightBreakeGraphic.visible = false;
		lightBreakeGraphic.antialiasing = true;
		lightBreakeGraphic.scale = new FlxPoint(carScale, carScale);
	}

	function buildPhysics(x:Float, y:Float, filterCategory:Int = 0, filterMask:Int = 0):Void
	{
		var filter = new InteractionFilter();
		filter.collisionGroup = filterCategory;
		filter.collisionMask = filterMask;

		var noHitFilter = new InteractionFilter();
		noHitFilter.collisionGroup = 0;
		noHitFilter.collisionMask = 0;

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

		if (hasFlag)
		{
			flagPhysics = new Body();
			flagPhysics.shapes.add(new Circle(5));
			flagPhysics.setShapeFilters(noHitFilter);
			flagPhysics.position.x = x + flagEndPointXOffet;
			flagPhysics.position.y = y + flagEndPointYOffet;
			flagPhysics.space = space;
			flagPhysics.mass = 0.001;
		}

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

		if (hasFlag)
		{
			var flagWeldAnchorA:Vec2 = new Vec2( flagEndPointXOffet * carScale - 20 * carScale, flagEndPointYOffet * carScale );
			var flagFrontJointWheel:PivotJoint = new PivotJoint(carBodyPhysics, flagPhysics, flagWeldAnchorA, flagPhysics.localCOM);
			flagFrontJointWheel.stiff = false;
			flagFrontJointWheel.damping = flagJoinDamping;
			flagFrontJointWheel.frequency = flagJoinHertz;
			flagFrontJointWheel.space = space;

			var flagWeldAnchorB:Vec2 = new Vec2( flagEndPointXOffet * carScale, flagEndPointYOffet * carScale );
			var flagFrontJointWheel:PivotJoint = new PivotJoint(carBodyPhysics, flagPhysics, flagWeldAnchorB, flagPhysics.localCOM);
			flagFrontJointWheel.stiff = false;
			flagFrontJointWheel.damping = flagJoinDamping;
			flagFrontJointWheel.frequency = flagJoinHertz;
			flagFrontJointWheel.space = space;
		}
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

		if (isHorizontalMoveDisabled)
		{
			carBodyPhysics.velocity.x = 0;
			wheelLeftPhysics.velocity.x = 0;
			wheelRightPhysics.velocity.x = 0;
		}

		carAngleCos = Math.cos(carBodyPhysics.rotation);
		carAngleSin = Math.sin(carBodyPhysics.rotation);
		carAngleRotatedCos = Math.cos(carBodyPhysics.rotation + Math.PI / 2);
		carAngleRotatedSin = Math.sin(carBodyPhysics.rotation + Math.PI / 2);

		updateMainCarComponnentGrraphic();
		updateSpringGraphic();
		updateWheelHolderGraphic();
		updateBreakeLightGraphic();

		if (hasFlag) updateFlagGraphic();

		calculateCollision();
	}

	function updateMainCarComponnentGrraphic()
	{
		carBodyGraphics.x = carBodyPhysics.position.x - carBodyGraphics.origin.x;
		carBodyGraphics.y = carBodyPhysics.position.y - carBodyGraphics.origin.y;
		carBodyGraphics.angle = carBodyPhysics.rotation * FlxAngle.TO_DEG;

		wheelRightGraphics.x = wheelRightPhysics.position.x - wheelRightGraphics.origin.x;
		wheelRightGraphics.y = wheelRightPhysics.position.y - wheelRightGraphics.origin.y;
		wheelRightGraphics.angle = wheelRightPhysics.rotation * FlxAngle.TO_DEG;

		wheelLeftGraphics.x = wheelLeftPhysics.position.x - wheelLeftGraphics.origin.x;
		wheelLeftGraphics.y = wheelLeftPhysics.position.y - wheelLeftGraphics.origin.y;
		wheelLeftGraphics.angle = wheelLeftPhysics.rotation * FlxAngle.TO_DEG;
	}

	function updateSpringGraphic()
	{
		frontSpring.x = carBodyPhysics.position.x + frontSpringHorizontalOffset * carAngleCos + frontSpringVerticalOffset * carAngleRotatedCos;
		frontSpring.y = carBodyPhysics.position.y + frontSpringHorizontalOffset * carAngleSin + frontSpringVerticalOffset * carAngleRotatedSin;
		frontSpring.scale.x = Point.distance(
			new Point(wheelRightGraphics.x + wheelRightGraphics.origin.x, wheelRightGraphics.y + wheelRightGraphics.origin.y),
			new Point(frontSpring.x, frontSpring.y)
		) / 59;
		frontSpring.angle = FlxAngle.TO_DEG * Math.atan2(
			wheelRightGraphics.y + wheelRightGraphics.origin.y - frontSpring.y,
			wheelRightGraphics.x + wheelRightGraphics.origin.x - frontSpring.x
		);

		backSpring.x = carBodyPhysics.position.x - backSpringHorizontalOffset * carAngleCos + backSpringVerticalOffset * carAngleRotatedCos;
		backSpring.y = carBodyPhysics.position.y - backSpringHorizontalOffset * carAngleSin + backSpringVerticalOffset * carAngleRotatedSin;
		backSpring.scale.x = Point.distance(
			new Point(wheelLeftGraphics.x + wheelLeftGraphics.origin.x, wheelLeftGraphics.y + wheelLeftGraphics.origin.y),
			new Point(backSpring.x, backSpring.y)
		) / 59;
		backSpring.angle = FlxAngle.TO_DEG * Math.atan2(
			wheelLeftGraphics.y + wheelLeftGraphics.origin.y - backSpring.y,
			wheelLeftGraphics.x + wheelLeftGraphics.origin.x - backSpring.x
		);
	}

	function updateWheelHolderGraphic()
	{
		wheelBackTopHolderGraphics.x = carBodyPhysics.position.x + backTopHolderHorizontalOffset * carAngleCos + backTopHolderVerticalOffset * carAngleRotatedCos;
		wheelBackTopHolderGraphics.y = carBodyPhysics.position.y + backTopHolderHorizontalOffset * carAngleSin + backTopHolderVerticalOffset * carAngleRotatedSin;
		wheelBackTopHolderGraphics.angle = FlxAngle.TO_DEG * Math.atan2(
			wheelLeftGraphics.y + wheelLeftGraphics.origin.y - wheelBackTopHolderGraphics.y,
			wheelLeftGraphics.x + wheelLeftGraphics.origin.x - wheelBackTopHolderGraphics.x
		);

		wheelBackBottomHolderGraphics.x = carBodyPhysics.position.x + backBottomHolderHorizontalOffset * carAngleCos + backBottomHolderVerticalOffset * carAngleRotatedCos;
		wheelBackBottomHolderGraphics.y = carBodyPhysics.position.y + backBottomHolderHorizontalOffset * carAngleSin + backBottomHolderVerticalOffset * carAngleRotatedSin;
		wheelBackBottomHolderGraphics.angle = FlxAngle.TO_DEG * Math.atan2(
			wheelLeftGraphics.y + wheelLeftGraphics.origin.y - wheelBackBottomHolderGraphics.y,
			wheelLeftGraphics.x + wheelLeftGraphics.origin.x - wheelBackBottomHolderGraphics.x
		);

		wheelFrontTopHolderGraphics.x = carBodyPhysics.position.x + frontTopHolderHorizontalOffset * carAngleCos + frontTopHolderVerticalOffset * carAngleRotatedCos;
		wheelFrontTopHolderGraphics.y = carBodyPhysics.position.y + frontTopHolderHorizontalOffset * carAngleSin + frontTopHolderVerticalOffset * carAngleRotatedSin;
		wheelFrontTopHolderGraphics.angle = FlxAngle.TO_DEG * Math.atan2(
			wheelRightGraphics.y + wheelRightGraphics.origin.y - wheelFrontTopHolderGraphics.y,
			wheelRightGraphics.x + wheelRightGraphics.origin.x - wheelFrontTopHolderGraphics.x
		);

		wheelFrontBottomHolderGraphics.x = carBodyPhysics.position.x + frontBottomHolderHorizontalOffset * carAngleCos + frontBottomHolderVerticalOffset * carAngleRotatedCos;
		wheelFrontBottomHolderGraphics.y = carBodyPhysics.position.y + frontBottomHolderHorizontalOffset * carAngleSin + frontBottomHolderVerticalOffset * carAngleRotatedSin;
		wheelFrontBottomHolderGraphics.angle = FlxAngle.TO_DEG * Math.atan2(
			wheelRightGraphics.y + wheelRightGraphics.origin.y - wheelFrontBottomHolderGraphics.y,
			wheelRightGraphics.x + wheelRightGraphics.origin.x - wheelFrontBottomHolderGraphics.x
		);
	}

	function updateFlagGraphic()
	{
		flagGraphic.x = carBodyPhysics.position.x - flagGraphic.origin.x + flagGraphicXOffset * carAngleCos + flagGraphicYOffset * carAngleRotatedCos;
		flagGraphic.y = carBodyPhysics.position.y - flagGraphic.origin.y + flagGraphicXOffset * carAngleSin + flagGraphicYOffset * carAngleRotatedSin;

		flagGraphic.angle = flagAngleOffset + FlxAngle.TO_DEG * (GeomUtil.getAngle(
			{
				x: flagGraphic.x + flagGraphic.origin.x,
				y: flagGraphic.y + flagGraphic.origin.y
			},
			{
				x: flagPhysics.position.x,
				y: flagPhysics.position.y
			}
		));
	}

	function updateBreakeLightGraphic()
	{
		lightBreakeGraphic.x = carBodyPhysics.position.x - lightBreakeGraphic.origin.x + lightBreakGraphicXOffset * carAngleCos + lightBreakGraphicYOffset * carAngleRotatedCos;
		lightBreakeGraphic.y = carBodyPhysics.position.y - lightBreakeGraphic.origin.y + lightBreakGraphicXOffset * carAngleSin + lightBreakGraphicYOffset * carAngleRotatedSin;
		lightBreakeGraphic.angle = carBodyGraphics.angle;
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

		lightBreakeGraphic.visible = true;
	}

	public function accelerateToRight():Void
	{
		direction = 1;

		wheelLeftPhysics.angularVel = carLeveledData.speed;
		wheelRightPhysics.angularVel = carLeveledData.speed;

		lightBreakeGraphic.visible = false;
	}

	public function idle():Void
	{
		lightBreakeGraphic.visible = false;
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

		if (hasFlag)
		{
			flagPhysics.position.x = x + flagEndPointXOffet;
			flagPhysics.position.y = y + flagEndPointYOffet;
			flagPhysics.velocity.setxy(0, 0);
		}

		update(0);
	}

	public function serialize(s:Serializer):Void
	{
		serializeSprite(s, carBodyGraphics);
		serializeSprite(s, wheelRightGraphics);
		serializeSprite(s, wheelLeftGraphics);
		serializeSprite(s, frontSpring);
		serializeSprite(s, backSpring);
		serializeSprite(s, wheelBackTopHolderGraphics);
		serializeSprite(s, wheelBackBottomHolderGraphics);
		serializeSprite(s, wheelFrontTopHolderGraphics);
		serializeSprite(s, wheelFrontBottomHolderGraphics);
	}

	private function serializeSprite(s:Serializer, sprite:FlxSprite):Void
	{
		s.serialize(Math.round(sprite.x));
		s.serialize(Math.round(sprite.y));
		s.serialize(Math.round(sprite.angle * 100) / 100);
	}
}