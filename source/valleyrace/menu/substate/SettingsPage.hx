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
import hpp.flixel.ui.PlaceHolder;
import hpp.ui.HAlign;
import hpp.util.JsFullScreenUtil;
import valleyrace.AppConfig;
import valleyrace.assets.Fonts;
import valleyrace.common.view.SmallButton;
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

	var musicCheckBox:HPPToggleButton;
	var musicText:FlxText;

	var soundCheckBox:HPPToggleButton;
	var soundText:FlxText;

	var fullScreenCheckBox:HPPToggleButton;
	var fullScreenText:FlxText;

	var backButton:HPPButton;

	function new(openWelcomePage:HPPButton->Void):Void
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
		baseBack.makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
		baseBack.scrollFactor.set();
		add(baseBack);

		var container:HPPVUIBox = new HPPVUIBox(20, HAlign.LEFT);
		container.scrollFactor.set();

		container.add(createMusicVolumeSetting());
		container.add(createSoundVolumeSetting());
		if (AppConfig.IS_DESKTOP_DEVICE) container.add(createFullscreenSetting());
		container.add(createAlphaAnimationSetting());

		container.x = FlxG.width / 2 - container.width / 2;
		container.y = FlxG.height / 2 - container.height / 2 - 50;
		add(container);

		add(backButton = new SmallButton("BACK", saveAndClose));
		backButton.x = FlxG.width / 2 - backButton.width / 2;
		backButton.y = FlxG.height - 40 - backButton.height;
	}

	function saveAndClose(target:HPPButton)
	{
		var settingsInfo:SettingsInfo = SavedDataUtil.getSettingsInfo();
		settingsInfo.enableAlphaAnimation = AppConfig.IS_ALPHA_ANIMATION_ENABLED;
		settingsInfo.musicVolume = AppConfig.MUSIC_VOLUME;
		settingsInfo.soundVolume = AppConfig.SOUND_VOLUME;
		SavedDataUtil.save();

		openWelcomePage(target);
	}

	function createFullscreenSetting():FlxSpriteGroup
	{
		var settingContainer:HPPHUIBox = new HPPHUIBox(20);

		fullScreenCheckBox = new HPPToggleButton("", "", setFullscreen, "checkbox_off", "checkbox_on");
		fullScreenCheckBox.isSelected = JsFullScreenUtil.isFullScreen();
		settingContainer.add(fullScreenCheckBox);

		var textWrapper:HPPVUIBox = new HPPVUIBox();
		textWrapper.add(new PlaceHolder(1,15));

		fullScreenText = new FlxText();
		fullScreenText.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		fullScreenText.color = FlxColor.WHITE;
		fullScreenText.alignment = "left";
		fullScreenText.size = 35;
		fullScreenText.font = Fonts.HOLLYWOOD;
		fullScreenText.borderStyle = FlxTextBorderStyle.SHADOW;
		fullScreenText.fieldWidth = 650;

		updateFullScreenText();
		textWrapper.add(fullScreenText);
		settingContainer.add(textWrapper);

		#if js
			untyped __js__('window.addEventListener("resize", ()=>this.updateFullScreenState())');
		#end

		return cast settingContainer;
	}

	function setFullscreen(target:HPPToggleButton):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);

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
		fullScreenText.text = "Change to full screen mode (" + (fullScreenCheckBox.isSelected ? "TURNED ON" : "TURNED OFF") + ") Note: On some site this feature is not available";
	}

	function createAlphaAnimationSetting():FlxSpriteGroup
	{
		var settingContainer:HPPHUIBox = new HPPHUIBox(20);

		alphaAnimationCheckBox = new HPPToggleButton("", "", setAlphaAnimation, "checkbox_off", "checkbox_on");
		alphaAnimationCheckBox.isSelected = AppConfig.IS_ALPHA_ANIMATION_ENABLED;
		settingContainer.add(alphaAnimationCheckBox);

		var textWrapper:HPPVUIBox = new HPPVUIBox();
		textWrapper.add(new PlaceHolder(1, 15));

		alphaAnimationsText = new FlxText();
		alphaAnimationsText.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		alphaAnimationsText.color = FlxColor.WHITE;
		alphaAnimationsText.alignment = "left";
		alphaAnimationsText.size = 35;
		alphaAnimationsText.font = Fonts.HOLLYWOOD;
		alphaAnimationsText.borderStyle = FlxTextBorderStyle.SHADOW;
		alphaAnimationsText.fieldWidth = 650;

		updateAlphaAnimationText();
		textWrapper.add(alphaAnimationsText);
		settingContainer.add(textWrapper);

		return cast settingContainer;
	}

	function setAlphaAnimation(target:HPPToggleButton):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);

		updateAlphaAnimationText();

		AppConfig.IS_ALPHA_ANIMATION_ENABLED = alphaAnimationCheckBox.isSelected;
	}

	function updateAlphaAnimationText():Void
	{
		alphaAnimationsText.text = "Enable alpha animations - Not recommended in mobile or with slow PC (" + (alphaAnimationCheckBox.isSelected ? "TURNED ON" : "TURNED OFF") + ")";
	}

	function createMusicVolumeSetting():FlxSpriteGroup
	{
		var settingContainer:HPPHUIBox = new HPPHUIBox(20);

		musicCheckBox = new HPPToggleButton("", "", setMusicVolume, "checkbox_off", "checkbox_on");
		musicCheckBox.isSelected = AppConfig.MUSIC_VOLUME == 1;
		settingContainer.add(musicCheckBox);

		var textWrapper:HPPVUIBox = new HPPVUIBox();
		textWrapper.add(new PlaceHolder(1, 15));

		musicText = new FlxText();
		musicText.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		musicText.color = FlxColor.WHITE;
		musicText.alignment = "left";
		musicText.size = 35;
		musicText.font = Fonts.HOLLYWOOD;
		musicText.borderStyle = FlxTextBorderStyle.SHADOW;
		musicText.fieldWidth = 650;

		updateMusicVolumeText();
		textWrapper.add(musicText);
		settingContainer.add(textWrapper);

		return cast settingContainer;
	}

	function setMusicVolume(target:HPPToggleButton):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);

		updateMusicVolumeText();

		AppConfig.MUSIC_VOLUME = musicCheckBox.isSelected ? 1 : 0;
		FlxG.sound.music.volume = AppConfig.MUSIC_VOLUME == 1 ? .75 : 0;
	}

	function updateMusicVolumeText():Void
	{
		musicText.text = "Enable music (" + (musicCheckBox.isSelected ? "TURNED ON" : "TURNED OFF") + ")";
	}

	function createSoundVolumeSetting():FlxSpriteGroup
	{
		var settingContainer:HPPHUIBox = new HPPHUIBox(20);

		soundCheckBox = new HPPToggleButton("", "", setSoundVolume, "checkbox_off", "checkbox_on");
		soundCheckBox.isSelected = AppConfig.SOUND_VOLUME == 1;
		settingContainer.add(soundCheckBox);

		var textWrapper:HPPVUIBox = new HPPVUIBox();
		textWrapper.add(new PlaceHolder(1, 15));

		soundText = new FlxText();
		soundText.offset.set(0, AppConfig.IS_SVG_FONT ? 7 : 0);
		soundText.color = FlxColor.WHITE;
		soundText.alignment = "left";
		soundText.size = 35;
		soundText.font = Fonts.HOLLYWOOD;
		soundText.borderStyle = FlxTextBorderStyle.SHADOW;
		soundText.fieldWidth = 650;

		updateSoundVolumeText();
		textWrapper.add(soundText);
		settingContainer.add(textWrapper);

		return cast settingContainer;
	}

	function setSoundVolume(target:HPPToggleButton):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);

		updateSoundVolumeText();

		AppConfig.SOUND_VOLUME = soundCheckBox.isSelected ? 1 : 0;
	}

	function updateSoundVolumeText():Void
	{
		soundText.text = "Enable sound effects (" + (soundCheckBox.isSelected ? "TURNED ON" : "TURNED OFF") + ")";
	}
}