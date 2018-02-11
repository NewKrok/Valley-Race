package valleyrace.menu.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.ui.HPPHUIBox;
import hpp.flixel.ui.HPPToggleButton;
import hpp.flixel.ui.HPPVUIBox;
import hpp.ui.HAlign;
import hpp.util.JsFullScreenUtil;
import valleyrace.AppConfig;
import valleyrace.assets.Fonts;
import valleyrace.common.view.LongButton;
import valleyrace.util.SavedDataUtil;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SettingsPage extends FlxSubState
{
	var openWelcomePage:HPPButton->Void;

	var alphaAnimationCheckBox:HPPToggleButton;
	var alphaAnimationsText:FlxText;

	var fullScreenCheckBox:HPPToggleButton;
	var fullScreenText:FlxText;

	var backButton:HPPButton;

	function new( openWelcomePage:HPPButton->Void ):Void
	{
		super();

		this.openWelcomePage = openWelcomePage;
	}

	override public function create():Void
	{
		super.create();

		build();
	}

	function build():Void
	{
		var baseBack:FlxSprite = new FlxSprite();
		baseBack.makeGraphic( FlxG.width, FlxG.height, 0xAA000000 );
		baseBack.scrollFactor.set();
		add( baseBack );

		var container:HPPVUIBox = new HPPVUIBox( 20, HAlign.LEFT );
		container.scrollFactor.set();

		if (AppConfig.IS_DESKTOP_DEVICE) container.add(createFullscreenSetting());
		container.add( createAlphaAnimationSetting() );

		container.x = FlxG.width / 2 - container.width / 2;
		container.y = FlxG.height / 2 - container.height / 2;
		add( container );

		add( backButton = new LongButton( "BACK", saveAndClose ) );
		backButton.x = FlxG.width / 2 - backButton.width / 2;
		backButton.y = FlxG.height - 40 - backButton.height;
	}

	function saveAndClose(target:HPPButton)
	{
		var settingsInfo:SettingsInfo = SavedDataUtil.getSettingsInfo();
		settingsInfo.enableAlphaAnimation = AppConfig.IS_ALPHA_ANIMATION_ENABLED;
		SavedDataUtil.save();

		openWelcomePage(target);
	}

	function createFullscreenSetting():FlxSpriteGroup
	{
		var settingContainer:HPPHUIBox = new HPPHUIBox(20);

		fullScreenCheckBox = new HPPToggleButton("", "", setFullscreen, "checkbox_off", "checkbox_on");
		fullScreenCheckBox.isSelected = JsFullScreenUtil.isFullScreen();
		settingContainer.add( fullScreenCheckBox );

		fullScreenText = new FlxText();
		fullScreenText.color = FlxColor.WHITE;
		fullScreenText.alignment = "left";
		fullScreenText.size = 35;
		fullScreenText.font = Fonts.HOLLYWOOD;
		fullScreenText.borderStyle = FlxTextBorderStyle.SHADOW;
		fullScreenText.fieldWidth = 650;

		updateFullScreenText();
		settingContainer.add(fullScreenText);

		#if js
			untyped __js__('window.addEventListener("resize", ()=>this.updateFullScreenState())');
		#end

		return cast settingContainer;
	}

	function setFullscreen(target:HPPToggleButton):Void
	{
		updateFullScreenText();

		if (JsFullScreenUtil.isFullScreen())
		{
			JsFullScreenUtil.cancelFullScreen();
		}
		else
		{
			JsFullScreenUtil.requestFullScreen();
		}
	}

	function updateFullScreenState()
	{
		fullScreenCheckBox.isSelected = JsFullScreenUtil.isFullScreen();
		updateFullScreenText();
	}

	function updateFullScreenText():Void
	{
		fullScreenText.text = "Change to full screen mode (" + ( fullScreenCheckBox.isSelected ? "TURNED ON" : "TURNED OFF" ) + ") Note: On some site this feature is not available";
	}

	function createAlphaAnimationSetting():FlxSpriteGroup
	{
		var settingContainer:HPPHUIBox = new HPPHUIBox( 20 );

		alphaAnimationCheckBox = new HPPToggleButton( "", "", setAlphaAnimation, "checkbox_off", "checkbox_on" );
		alphaAnimationCheckBox.isSelected = AppConfig.IS_ALPHA_ANIMATION_ENABLED;
		settingContainer.add( alphaAnimationCheckBox );

		alphaAnimationsText = new FlxText();
		alphaAnimationsText.color = FlxColor.WHITE;
		alphaAnimationsText.alignment = "left";
		alphaAnimationsText.size = 35;
		alphaAnimationsText.font = Fonts.HOLLYWOOD;
		alphaAnimationsText.borderStyle = FlxTextBorderStyle.SHADOW;
		alphaAnimationsText.fieldWidth = 650;
		updateAlphaAnimationText();
		settingContainer.add( alphaAnimationsText );

		return cast settingContainer;
	}

	function setAlphaAnimation( target:HPPToggleButton ):Void
	{
		updateAlphaAnimationText();

		AppConfig.IS_ALPHA_ANIMATION_ENABLED = alphaAnimationCheckBox.isSelected;
	}

	function updateAlphaAnimationText():Void
	{
		alphaAnimationsText.text = "Enable alpha animations - Not recommended in mobile or with slow PC (" + ( alphaAnimationCheckBox.isSelected ? "TURNED ON" : "TURNED OFF" ) + ")";
	}
}