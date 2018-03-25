package valleyrace.game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.util.HPPAssetManager;
import openfl.events.TouchEvent;
import valleyrace.AppConfig;
import valleyrace.game.view.counter.BonusCounter;
import valleyrace.game.NotificationHandler.Notification;
import valleyrace.game.view.counter.CoinCounter;
import valleyrace.game.view.counter.TimeCounter;

/**
 * ...
 * @author Krisztian Somoracz
 */
class GameGui extends FlxSpriteGroup
{
	public var controlLeftState(default, null):Bool;
	public var controlRightState(default, null):Bool;
	public var controlUpState(default, null):Bool;
	public var controlDownState(default, null):Bool;

	var notificationHandler:NotificationHandler;

	var touches:Map<Int, FlxSprite>;

	var coinCounter:CoinCounter;
	var timeCounter:TimeCounter;
	var startCounter:StartCounter;
	var topContainer:HPPHUIBox;

	var controlLeft:FlxSprite;
	var controlRight:FlxSprite;
	var controlUp:FlxSprite;
	var controlDown:FlxSprite;

	var pauseButton:HPPButton;
	var frontFlipCounter:BonusCounter;
	var backFlipCounter:BonusCounter;
	var wheelieCounter:BonusCounter;

	public function new(resumeGameCallBack:Void->Void, pauseGameCallBack:HPPButton->Void, maxCoinCount:UInt)
	{
		super();

		touches = new Map<Int, FlxSprite>();

		topContainer = new HPPHUIBox(10);
		topContainer.x = 15;
		topContainer.y = 15;

		topContainer.add(timeCounter = new TimeCounter());
		topContainer.add(coinCounter = new CoinCounter(0, maxCoinCount));
		/*topContainer.add(*/frontFlipCounter = new BonusCounter("gui_frontflip_back");// );
		/*topContainer.add(*/backFlipCounter = new BonusCounter("gui_backflip_back");// );
		/*topContainer.add(*/wheelieCounter = new BonusCounter("gui_wheelie_back");// );

		add(topContainer);
		add(startCounter = new StartCounter(resumeGameCallBack));

		add(pauseButton = new HPPButton("", pauseGameCallBack, "pause_button", "pause_button_over"));
		pauseButton.overScale = .95;
		pauseButton.x = FlxG.stage.stageWidth - pauseButton.width - 10;
		pauseButton.y = 15;

		add(notificationHandler = new NotificationHandler());

		if (AppConfig.IS_MOBILE_DEVICE)
		{
			createControlButtons();
		}

		scrollFactor.set();
	}

	public function pause():Void
	{
		startCounter.stop();

		FlxTween.tween(topContainer, { y: -topContainer.height }, .5, { ease: FlxEase.backOut });
	}

	public function resumeGameRequest():Void
	{
		startCounter.start();

		topContainer.y = -topContainer.height;
		FlxTween.tween(topContainer, { y: 15 }, .5, { ease: FlxEase.backOut });
	}

	function createControlButtons()
	{
		var padding:UInt = 10;

		var leftBlock:HPPHUIBox = new HPPHUIBox(padding);
		add(leftBlock);
		leftBlock.add(controlLeft = HPPAssetManager.getSprite("control_left"));
		leftBlock.add(controlRight = HPPAssetManager.getSprite("control_right"));
		leftBlock.x = padding;
		leftBlock.y = FlxG.height - leftBlock.height - padding;

		var rightBlock:HPPHUIBox = new HPPHUIBox(padding);
		add(rightBlock);
		rightBlock.add(controlDown = HPPAssetManager.getSprite("control_down"));
		rightBlock.add(controlUp = HPPAssetManager.getSprite("control_up"));
		rightBlock.x = FlxG.width - rightBlock.width - padding;
		rightBlock.y = leftBlock.y;

		FlxG.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		FlxG.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		FlxG.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
	}

	function onTouchBegin(e:TouchEvent)
	{
		var touchPoint:FlxPoint = new FlxPoint(e.stageX, e.stageY);
		var touchSprite:FlxSprite = null;

		if (controlLeft.overlapsPoint(touchPoint))
		{
			controlLeftState = true;
			touchSprite = controlLeft;
		}
		if (controlRight.overlapsPoint(touchPoint))
		{
			controlRightState = true;
			touchSprite = controlRight;
		}
		if (controlUp.overlapsPoint(touchPoint))
		{
			controlUpState = true;
			touchSprite = controlUp;
		}
		if (controlDown.overlapsPoint(touchPoint))
		{
			controlDownState = true;
			touchSprite = controlDown;
		}

		if (touchSprite != null)
		{
			touchSprite.scale.set(1.1, 1.1);
			touches.set(e.touchPointID, touchSprite);
		}
	}

	function onTouchEnd(e:TouchEvent)
	{
		var touchPoint:FlxPoint = new FlxPoint(e.stageX, e.stageY);

		if (controlLeft.overlapsPoint(touchPoint))
		{
			controlLeftState = false;
			controlLeft.scale.set(1, 1);
		}
		if (controlRight.overlapsPoint(touchPoint))
		{
			controlRightState = false;
			controlRight.scale.set(1, 1);
		}
		if (controlUp.overlapsPoint(touchPoint))
		{
			controlUpState = false;
			controlUp.scale.set(1, 1);
		}
		if (controlDown.overlapsPoint(touchPoint))
		{
			controlDownState = false;
			controlDown.scale.set(1, 1);
		}

		touches.remove(e.touchPointID);
	}

	function onTouchMove(e:TouchEvent)
	{
		var touchPoint:FlxPoint = new FlxPoint(e.stageX, e.stageY);

		var touchSprite:FlxSprite = touches.get(e.touchPointID);

		if (touchSprite != null && !touchSprite.overlapsPoint(touchPoint))
		{
			if (touchSprite == controlLeft) controlLeftState = false;
			if (touchSprite == controlRight) controlRightState = false;
			if (touchSprite == controlUp) controlUpState = false;
			if (touchSprite == controlDown) controlDownState = false;

			touchSprite.scale.set(1, 1);
			touches.remove(e.touchPointID);
		}
	}

	public function addNotification(type:Notification):Void
	{
		notificationHandler.addEntry(type);
	}

	public function updateCoinCount(value:UInt):Void
	{
		coinCounter.setValue(value);
	}

	public function updateFrontFlipCount(value:UInt):Void
	{
		frontFlipCounter.setValue(value);
	}

	public function updateBackFlipCount(value:UInt):Void
	{
		backFlipCounter.setValue(value);
	}

	public function updateWheelieCount(value:UInt):Void
	{
		wheelieCounter.setValue(value);
	}

	public function updateRemainingTime(value:Float):Void
	{
		timeCounter.setValue(value);
	}

	override public function destroy():Void
	{
		FlxG.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		FlxG.stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		FlxG.stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);

		super.destroy();
	}
}