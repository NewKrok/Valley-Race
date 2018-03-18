package valleyrace.game;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import hpp.flixel.display.HPPMovieClip;
import hpp.flixel.util.HPPAssetManager;
import valleyrace.config.BackgroundConfigs;
import valleyrace.config.BackgroundConfigs.BackgroundConfig;
import valleyrace.datatype.BackgroundData;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Background extends FlxSpriteGroup
{
	public var worldId(default, set):UInt;

	var backgroundDatas:Array<BackgroundData>;
	var lastCameraStepOffset:FlxPoint;

	public function new(worldId:UInt)
	{
		super();

		lastCameraStepOffset = new FlxPoint();

		this.worldId = worldId;

		scrollFactor.set();
	}

	function set_worldId(value:UInt):UInt
	{
		if (value != worldId)
		{
			worldId = value;
			build();
		}

		return  worldId;
	}

	function build():Void
	{
		removeCurrent();

		backgroundDatas = [];

		var configList = BackgroundConfigs.getConfigConfigByWorld(worldId);
		for (config in configList) addBackground(config);

		update(1);
	}

	function removeCurrent():Void
	{
		if (backgroundDatas != null)
		{
			for (backgroundData in backgroundDatas)
			{
				backgroundData.container.destroy();
				backgroundData = null;
			}
		}

		backgroundDatas = null;
	}

	function addBackground(config:BackgroundConfig):Void
	{
		var backgroundData:BackgroundData = {
			easing: config.easing,
			container: new FlxSpriteGroup(),
			elements: []
		};
		backgroundDatas.push(backgroundData);

		add(backgroundData.container);
		backgroundData.container.scrollFactor.set();

		for (i in 0...5)
		{
			var backgroundPiece:HPPMovieClip = HPPAssetManager.getMovieClip(config.assetId, "00");
			backgroundData.container.add(backgroundPiece);
			backgroundData.elements.push(backgroundPiece);

			backgroundPiece.gotoAndStop(i == 4 ? 0 : i);
			backgroundPiece.x = i * (backgroundPiece.width + config.xOverlap);
			backgroundPiece.y = config.baseYOffset;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		lastCameraStepOffset.set(camera.scroll.x - lastCameraStepOffset.x, camera.scroll.y - lastCameraStepOffset.y);

		for (i in 0...backgroundDatas.length)
		{
			var backgroundData:BackgroundData = backgroundDatas[i];

			backgroundData.container.x -= lastCameraStepOffset.x * backgroundData.easing.x;

			while (backgroundData.container.x > 0)
			{
				for (j in 0...backgroundData.elements.length)
				{
					backgroundData.elements[j].currentFrame = backgroundData.elements[j].currentFrame == 0 ? backgroundData.elements[j].numFrames - 1 : backgroundData.elements[j].currentFrame - 1;
				}
				backgroundData.container.x -= backgroundData.elements[ 0 ].width;
			}

			while (backgroundData.container.x < -backgroundData.elements[ 0 ].width)
			{
				for (j in 0...backgroundData.elements.length)
				{
					backgroundData.elements[j].currentFrame = (backgroundData.elements[j] .currentFrame == cast(backgroundData.elements[j].numFrames - 1)) ? 0 : backgroundData.elements[j].currentFrame + 1;
				}
				backgroundData.container.x += backgroundData.elements[ 0 ].width;
			}

			backgroundData.container.y = FlxG.height - backgroundData.container.height - camera.scroll.y * backgroundData.easing.y;
		}

		lastCameraStepOffset.set(camera.scroll.x, camera.scroll.y);
	}

	override public function destroy():Void
	{
		removeCurrent();

		super.destroy();
	}
}