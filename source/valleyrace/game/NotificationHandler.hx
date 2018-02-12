package valleyrace.game;

import flixel.group.FlxSpriteGroup;
import valleyrace.game.view.NotificationView;

/**
 * ...
 * @author Krisztian Somoracz
 */
class NotificationHandler extends FlxSpriteGroup
{
	static inline var MARGIN_LEFT:UInt = 20;
	static inline var MARGIN_TOP:UInt = 90;
	static inline var NOTIFICATION_HEIGHT:UInt = 60;
	static inline var NOTIFICATION_GAP:UInt = 5;

	var list:Array<NotificationView> = [];

	public function addEntry(type:Notification):Void
	{
		switch(type)
		{
			case Notification.FRONT_FLIP: addFrontFlipNotification();
			case Notification.BACK_FLIP: addBackFlipNotification();
			case Notification.NICE_WHEELIE: addNiceWheelieTimeNotification();
		}
	}

	public function addFrontFlipNotification():Void
	{
		addNotification("notification_front_flip");
	}

	public function addBackFlipNotification():Void
	{
		addNotification("notification_back_flip");
	}

	public function addNiceWheelieTimeNotification():Void
	{
		addNotification("notification_nice_wheelie");
	}

	private function addNotification(imageName:String):Void
	{
		var notificationView:NotificationView = new NotificationView(removeNotification, imageName);
		setStartPositionOfNotificationView(notificationView);
		notificationView.show();

		list.push(notificationView);
		add(notificationView);
	}

	function removeNotification(view:NotificationView):Void
	{
		for (notificationView in list)
		{
			if (notificationView == view)
			{
				list.remove(notificationView);
				notificationView.destroy();
				notificationView = null;

				break;
			}
		}

		updatePositions();
	}

	function updatePositions():Void
	{
		var length:Int = list.length;
		for(i in 0...length)
		{
			setyPositionOfNotificationViewWithAnimation(i, list[ i ]);
		}
	}

	function setStartPositionOfNotificationView(notificationView:NotificationView):Void
	{
		notificationView.x = MARGIN_LEFT;
		notificationView.y = MARGIN_TOP + list.length * NOTIFICATION_HEIGHT + list.length * NOTIFICATION_GAP;
	}

	function setyPositionOfNotificationViewWithAnimation(index:UInt, notificationView:NotificationView):Void
	{
		notificationView.animateY(MARGIN_TOP + index * NOTIFICATION_HEIGHT + index * NOTIFICATION_GAP);
	}
}

enum Notification
{
	FRONT_FLIP;
	BACK_FLIP;
	NICE_WHEELIE;
}