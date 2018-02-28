package valleyrace.game;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.datatype.CarData;

class AbstractCar extends FlxSpriteGroup
{
	var carData:CarData;

	public var carScale:Float;
	public var carBodyGraphics:FlxSprite;
	public var wheelRightGraphics:FlxSprite;
	public var wheelLeftGraphics:FlxSprite;
	public var wheelBackTopHolderGraphics:FlxSprite;
	public var wheelBackBottomHolderGraphics:FlxSprite;
	public var wheelFrontTopHolderGraphics:FlxSprite;
	public var wheelFrontBottomHolderGraphics:FlxSprite;
	public var backSpring:FlxSprite;
	public var frontSpring:FlxSprite;

	public var id(get, null):UInt;

	public function new(carData:CarData, scale:Float = 1)
	{
		super();

		carScale = scale;

		this.carData = carData;

		buildGraphics();

		carBodyGraphics.scale = new FlxPoint(scale, scale);
		wheelRightGraphics.scale = new FlxPoint(scale, scale);
		wheelLeftGraphics.scale = new FlxPoint(scale, scale);
		wheelBackTopHolderGraphics.scale = new FlxPoint(scale, scale);
		wheelBackBottomHolderGraphics.scale = new FlxPoint(scale, scale);
		wheelFrontTopHolderGraphics.scale = new FlxPoint(scale, scale);
		wheelFrontBottomHolderGraphics.scale = new FlxPoint(scale, scale);
		backSpring.scale = new FlxPoint(scale, scale);
		frontSpring.scale = new FlxPoint(scale, scale);
	}

	function buildGraphics():Void
	{
		add(carBodyGraphics = HPPAssetManager.getSprite("car_body_" + carData.graphicId));
		carBodyGraphics.antialiasing = true;

		add(backSpring = HPPAssetManager.getSprite("spring"));
		backSpring.origin.set(0, 0);
		backSpring.antialiasing = true;

		add(frontSpring = HPPAssetManager.getSprite("spring"));
		frontSpring.origin.set(0, 0);
		frontSpring.antialiasing = true;

		add(wheelBackTopHolderGraphics = HPPAssetManager.getSprite("wheel_holder"));
		wheelBackTopHolderGraphics.origin.set(0, 0);
		wheelBackTopHolderGraphics.antialiasing = true;

		add(wheelBackBottomHolderGraphics = HPPAssetManager.getSprite("wheel_holder"));
		wheelBackBottomHolderGraphics.origin.set(0, 0);
		wheelBackBottomHolderGraphics.antialiasing = true;

		add(wheelFrontTopHolderGraphics = HPPAssetManager.getSprite("wheel_holder"));
		wheelFrontTopHolderGraphics.origin.set(0, 0);
		wheelFrontTopHolderGraphics.antialiasing = true;

		add(wheelFrontBottomHolderGraphics = HPPAssetManager.getSprite("wheel_holder"));
		wheelFrontBottomHolderGraphics.origin.set(0, 0);
		wheelFrontBottomHolderGraphics.antialiasing = true;

		add(wheelRightGraphics = HPPAssetManager.getSprite("wheel_" + carData.graphicId));
		wheelRightGraphics.antialiasing = true;

		add(wheelLeftGraphics = HPPAssetManager.getSprite("wheel_" + carData.graphicId));
		wheelLeftGraphics.antialiasing = true;
	}

	function get_id():UInt { return carData.id; }
}