package valleyrace.game.view.counter;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import hpp.flixel.util.HPPAssetManager;
import hpp.util.TimeUtil;
import valleyrace.assets.Fonts;
import valleyrace.game.view.endlevelpanel.IValueContainer;

/**
 * ...
 * @author Krisztian Somoracz
 */
class TimeCounter extends FlxSpriteGroup implements IValueContainer
{
	var background:FlxSprite;
	var text:FlxText;

	public function new(defaultValue:Float = 0)
	{
		super();

		add(background = HPPAssetManager.getSprite("gui_time_back"));

		text = new FlxText(45, 0, cast width - 40, "00:00", 30);
		text.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		text.autoSize = false;
		text.color = 0xFF26FF92;
		text.alignment = "center";
		text.font = Fonts.HOLLYWOOD;
		text.borderStyle = FlxTextBorderStyle.SHADOW;
		text.borderSize = 2;
		text.borderColor = 0x95000000;
		text.y = 13;

		add(text);

		setValue(defaultValue);
	}

	public function setValue(value:Float):Void
	{
		if(value <= 1000 * 10)
		{
			text.color = 0xFFFFB399;
		}
		else
		{
			text.color = 0xFF26FF92;
		}

		text.text = TimeUtil.timeStampToFormattedTime(value, TimeUtil.TIME_FORMAT_MM_SS);
	}
}