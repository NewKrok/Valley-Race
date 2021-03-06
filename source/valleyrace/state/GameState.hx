package valleyrace.state;

import apostx.replaykit.Playback;
//import apostx.replaykit.Recorder;
import flixel.FlxCamera;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Timer;
import hpp.flixel.HPPCamera;
import hpp.flixel.ui.HPPButton;
import hpp.flixel.util.HPPAssetManager;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import openfl.Assets;
import openfl.geom.Point;
import valleyrace.AppConfig;
import valleyrace.assets.CarDatas;
import valleyrace.datatype.LevelData;
import valleyrace.game.Background;
import valleyrace.game.Car;
import valleyrace.game.CarFog;
import valleyrace.game.Coin;
import valleyrace.game.GameGui;
import valleyrace.game.LevelEndData;
import valleyrace.game.NotificationHandler.Notification;
import valleyrace.game.OpponentCar;
import valleyrace.game.SmallRock;
import valleyrace.game.constant.CGameTimeValue;
import valleyrace.game.constant.CLibraryElement;
import valleyrace.game.constant.CPhysicsValue;
import valleyrace.game.library.crate.AbstractCrate;
import valleyrace.game.library.crate.Crate;
import valleyrace.game.library.crate.LongCrate;
import valleyrace.game.library.crate.RampCrate;
import valleyrace.game.library.crate.SmallCrate;
import valleyrace.game.library.crate.SmallLongCrate;
import valleyrace.game.library.crate.SmallRampCrate;
import valleyrace.game.snow.Snow;
import valleyrace.game.substate.EndLevelPanel;
import valleyrace.game.substate.LevelPreloader;
import valleyrace.game.substate.PausePanel;
import valleyrace.game.substate.StartLevelPanel;
import valleyrace.game.terrain.BrushTerrain;
import valleyrace.game.view.CarMarker;
import valleyrace.state.MenuState.MenuSubStateType;
import valleyrace.util.LevelUtil;
import valleyrace.util.SavedDataUtil;
import valleyrace.util.ScoreUtil;


class GameState extends FlxState
{
	static inline var CAR_SCALE:Float = .75;

	var space:Space;

	var polygonBackgrounds:Array<BrushTerrain> = [];

	var levelPreloader:LevelPreloader;
	var startLevelPanel:StartLevelPanel;
	var endLevelPanel:EndLevelPanel;
	var pausePanel:PausePanel;
	var gameGui:GameGui;
	var carMarker:CarMarker;
	var background:Background;

	var container:FlxSpriteGroup;
	var coinContainer:FlxSpriteGroup;
	var libraryElementContainer:FlxSpriteGroup;

	var lastCameraStepOffset:FlxPoint;

	var groundBodies:Array<Body>;

	var bridgeBodies:Array<Array<Body>>;
	var bridgeBlocks:Array<Array<FlxSprite>>;

	var smallRocks:Array<SmallRock>;
	var usedSmallRocks:Array<SmallRock>;

	var carFogs:Array<CarFog>;
	var usedCarFogs:Array<CarFog>;

	var coins:Array<Coin>;

	var staticElements:Array<FlxSprite>;

	//var recorder:Recorder;

	var car:Car;
	var snow:Snow;

	var opponents:Array<OpponentCar>;
	var replayDatas:Array<String>;
	var playbacks:Array<Playback>;

	var effects:Array<FlxSprite> = [];
	var crates:Array<AbstractCrate> = [];

	var levelData:LevelData;
	var levelId:UInt;
	var worldId:UInt;

	var left:Bool;
	var right:Bool;
	var up:Bool;
	var down:Bool;

	var gameTime:Float = 0;
	var gameStartTime:Float = 0;
	var pauseStartTime:Float = 0;
	var totalPausedTime:Float = 0;

	var collectedCoin:UInt = 0;

	var countOfFrontFlip:UInt = 0;
	var countOfBackFlip:UInt = 0;
	var countOfNiceWheelie:UInt = 0;

	var isLost:Bool;
	var isWon:Bool;
	var isLevelFinished:Bool;
	var canControll:Bool;
	var isGameStarted:Bool;
	var isRaceStarted:Bool;
	var isGamePaused:Bool;
	var isPhysicsEnabled:Bool;

	var now:Float;

	var levelInfo:LevelSavedData;
	var buildStep:UInt = 0;
	var isBuilt:Bool = false;
	var playerPosition:UInt = 0;
	var engineSound:FlxSound;

	public function new(worldId:UInt, levelId:UInt):Void
	{
		super();

		this.worldId = worldId;
		this.levelId = levelId;

		levelInfo = SavedDataUtil.getLevelInfo(worldId, levelId);
		SavedDataUtil.resetLastPlayedInfo();
		levelInfo.isLastPlayed = true;
		SavedDataUtil.setLastPlayedWorldId(worldId);
		SavedDataUtil.save();
	}

	override public function create():Void
	{
		super.create();

		loadAssets();

		if (Main.DEBUG_LEVEL != "")
		{
			levelData = LevelUtil.LevelDataFromJson(Main.DEBUG_LEVEL);
		}
		else
		{
			levelData = LevelUtil.LevelDataFromJson(Assets.getText("assets/data/level/world_" + worldId + "/level_" + worldId + "_" + levelId + ".json"));
			levelData.levelId = levelId;
			levelData.worldId = worldId;
		}

		replayDatas = [];

		if (worldId != 2)
		{
			try {
				var replayData:String = Assets.getText("assets/data/replay/world_" + worldId + "/replay_" + worldId + "_" + levelId + "_0.txt");
				if (replayData != null) replayDatas.push(replayData);
				replayData = Assets.getText("assets/data/replay/world_" + worldId + "/replay_" + worldId + "_" + levelId + "_1.txt");
				if (replayData != null) replayDatas.push(replayData);
				replayData = Assets.getText("assets/data/replay/world_" + worldId + "/replay_" + worldId + "_" + levelId + "_2.txt");
				if (replayData != null) replayDatas.push(replayData);
			}
			catch (e:Dynamic){ trace("Invalid or missing replay data."); }
		}

		levelPreloader = new LevelPreloader();
		openSubState(levelPreloader);

		Timer.delay(build, 10);
	}

	function loadAssets():Void
	{
		HPPAssetManager.loadXMLAtlas("assets/images/atlas1.png", "assets/images/atlas1.xml");
		HPPAssetManager.loadXMLAtlas("assets/images/atlas2.png", "assets/images/atlas2.xml");
		HPPAssetManager.loadXMLAtlas("assets/images/atlas3.png", "assets/images/atlas3.xml");

		HPPAssetManager.loadJsonAtlas("assets/images/terrain_textures.png", "assets/images/terrain_textures.json");
	}

	function build():Void
	{
		switch (buildStep)
		{
			case 0:
				destroySubStates = false;
				pausePanel = new PausePanel(resumeRequest, restartRequest, exitRequest);

			case 1:
				endLevelPanel = new EndLevelPanel(levelInfo, levelData, restartRequest, exitRequest, nextLevelRequest, prevLevelRequest);

			case 2:
				lastCameraStepOffset = new FlxPoint();

				add(background = new Background(worldId));
				add(container = new FlxSpriteGroup());

				createCamera();
				createPhysicsWorld();

			case 3:
				for (i in 0...levelData.polygonGroundData.length)
					for (j in 0...levelData.polygonGroundData[i].length)
						for (backgroundData in levelData.polygonGroundData[i][j])
							createGroundPhysics(i, j, backgroundData.polygon);

			case 4:
				for (i in 0...levelData.polygonBackgroundData.length)
					for (j in 0...levelData.polygonBackgroundData[i].length)
						createPolygonGraphics(i, j, levelData.polygonBackgroundData[i][j]);

			case 5:
				createOpponentCars();
				createStaticElements();
				if (AppConfig.IS_DESKTOP_DEVICE) createCarFogs();
				createCar();
				createBridges();
				if (AppConfig.IS_DESKTOP_DEVICE) createSmallRocks();

			case 6:
				for (i in 0...levelData.polygonGroundData.length)
					for (j in 0...levelData.polygonGroundData[i].length)
						createPolygonGraphics(i, j, levelData.polygonGroundData[i][j]);

			case 7:
				createCoins();
				createLibraryElements();

				camera.follow(car.carBodyGraphics, FlxCameraFollowStyle.PLATFORMER, 5 / FlxG.updateFramerate);

				/*switch (worldId)
				{
					case 1:
						snow = new Snow();
						add(snow);
				}*/

				add(carMarker = new CarMarker());
				add(gameGui = new GameGui(resume, pauseRequest, levelData.collectableItems.length));

			case 8:
				levelPreloader.hide(removePreloader);
				return;
		}

		levelPreloader.step();
		buildStep++;
		Timer.delay(build, 10);
	}

	function removePreloader()
	{
		closeSubState();
		remove(levelPreloader);
		levelPreloader = null;

		reset();
		isBuilt = true;
	}

	function openStartLevelPanelRequest(target:HPPButton = null):Void
	{
		if (startLevelPanel != null)
		{
			startLevelPanel.destroy();
			startLevelPanel = null;
		}

		startLevelPanel = new StartLevelPanel(levelInfo, resumeRequest, exitRequest, nextLevelRequest, prevLevelRequest);
		openSubState(startLevelPanel);

		gameGui.visible = false;
		//gameOverRutin();
	}

	function reset():Void
	{
		isLost = false;
		isWon = false;
		isLevelFinished = false;
		canControll = true;
		left = false;
		right = false;
		up = false;
		down = false;
		isRaceStarted = false;
		isGameStarted = false;
		isGamePaused = false;
		collectedCoin = 0;
		countOfFrontFlip = 0;
		countOfBackFlip = 0;
		countOfNiceWheelie = 0;
		gameTime = 0;
		totalPausedTime = 0;
		pauseStartTime = 0;
		playerPosition = 0;

		car.isOnWheelie = false;
		car.isOnAir = false;
		car.jumpAngle = 0;
		car.lastAngleOnGround = 0;

		gameGui.updateCoinCount(collectedCoin);
		gameGui.updateRemainingTime(CGameTimeValue.MAXIMUM_GAME_TIME);

		for (i in 0...coins.length)
		{
			coins[ i ].reset(levelData.collectableItems[ i ].x, levelData.collectableItems[ i ].y);
		}

		if (AppConfig.IS_DESKTOP_DEVICE) for (rock in smallRocks) rock.reset(0, 0);

		//car.teleportTo(levelData.startPoint.x - 540, levelData.startPoint.y); // -180 / -360 / -540 for ghosts
		car.teleportTo(levelData.startPoint.x, levelData.startPoint.y);

		carMarker.visible = true;
		carMarker.x = car.carBodyPhysics.position.x + 10;
		carMarker.y = car.carBodyPhysics.position.y - 55;

		var w:Float = camera.width / 8;
		camera.deadzone.x = (camera.width - w) / 2;
		cast(camera, HPPCamera).resetPosition();
		camera.focusOn(car.carBodyGraphics.getPosition());

		background.update(1);
		lastCameraStepOffset.set(camera.scroll.x, camera.scroll.y);

		resetCrates();
		updateBridges();

		start();

		resetReplayKit();

		openStartLevelPanelRequest();
		pause();
		isPhysicsEnabled = true;
	}

	function resetReplayKit():Void
	{
		/*if (recorder != null) recorder.dispose();
		recorder = new Recorder(car);
		recorder.enableAutoRecording(250);*/

		if (playbacks != null)
		{
			for (playback in playbacks)
			{
				playback.dispose();
				playbacks.remove(playback);
			}
		}
		playbacks = [];

		if (replayDatas != null)
		{
			for (i in 0...replayDatas.length)
			{
				var playback = new Playback(opponents[i], replayDatas[i]);
				playback.showSnapshot(0);
				playbacks.push(playback);
			}
		}
	}

	function resetCrates():Void
	{
		for(i in 0...crates.length)
		{
			crates[ i ].resetToDefault();
		}
	}

	function start():Void
	{
		isGameStarted = true;

		now = gameStartTime = Date.now().getTime();
		FlxG.sound.playMusic("assets/music/game_loop.ogg", AppConfig.MUSIC_VOLUME == 1 ? .75 : 0, true);
		engineSound = FlxG.sound.play("assets/sounds/engine.ogg", AppConfig.SOUND_VOLUME, true);

		resumeRequest();

		isPhysicsEnabled = true;
		persistentUpdate = true;
	}

	function resumeRequest(target:HPPButton = null):Void
	{
		gameGui.visible = true;

		closeSubState();

		if (!isGamePaused)
		{
			pause();
		}
		else
		{
			gameGui.resumeGameRequest();
		}
	}

	function pauseRequest(target:HPPButton = null):Void
	{
		FlxG.sound.play("assets/sounds/button.ogg", AppConfig.SOUND_VOLUME);

		if (subState == null)
		{
			openSubState(pausePanel);
			engineSound.volume = AppConfig.SOUND_VOLUME == 1 ? .5 : 0;
			pause();
		}
	}

	function resume():Void
	{
		engineSound.volume = AppConfig.SOUND_VOLUME == 1 ? 1 : 0;

		isRaceStarted = true;
		isGamePaused = false;
		isPhysicsEnabled = true;
		carMarker.visible = false;

		totalPausedTime += now - pauseStartTime;
		pauseStartTime = 0;

		/*if (recorder != null)
		{
			recorder.resume();
		}*/
	}

	function pause():Void
	{
		isGamePaused = true;
		isPhysicsEnabled = false;

		gameGui.pause();

		if (pauseStartTime != 0) totalPausedTime += now - pauseStartTime;

		pauseStartTime = now;

		/*if (recorder != null)
		{
			recorder.pause();
		}*/
	}

	function createCamera():Void
	{
		camera = new HPPCamera();
		/*cast(camera, HPPCamera).speedZoomEnabled = true;
		cast(camera, HPPCamera).maxSpeedZoom = 2;
		cast(camera, HPPCamera).speedZoomRatio = 100;*/
		camera.bgColor = FlxColor.BLACK;
		camera.targetOffset.set(200, -50);
		camera.setScrollBoundsRect(levelData.cameraBounds.x, levelData.cameraBounds.y, levelData.cameraBounds.width, levelData.cameraBounds.height);

		FlxG.cameras.remove(FlxG.cameras.list[0], false);
		FlxG.camera = camera;
		FlxG.cameras.add(camera);
		FlxCamera.defaultCameras = [ camera ];
	}

	function createPhysicsWorld():Void
	{
		space = new Space(new Vec2(0, CPhysicsValue.GRAVITY));

		var walls:Body = new Body(BodyType.STATIC);
		walls.shapes.add(new Polygon(Polygon.rect(0, 0, 1, levelData.cameraBounds.height)));
		walls.shapes.add(new Polygon(Polygon.rect(levelData.cameraBounds.width, 0, 1, levelData.cameraBounds.height)));
		walls.space = space;
	}

	function createPolygonGraphics(row:UInt, col:UInt, polygonBackgroundData:Array<PolygonBackgroundData>):Void
	{
		var terrainContainer = new FlxSpriteGroup();
		container.add(terrainContainer);

		var generatedTerrain:BrushTerrain = new BrushTerrain(
			row, col,
			{ x: AppConfig.WORLD_PIECE_SIZE.x, y: AppConfig.WORLD_PIECE_SIZE.y },
			polygonBackgroundData,
			64,
			20
		);
		generatedTerrain.scrollFactor.set();
		generatedTerrain.x = row * AppConfig.WORLD_PIECE_SIZE.x;
		generatedTerrain.y = col * AppConfig.WORLD_PIECE_SIZE.y;

		polygonBackgrounds.push(generatedTerrain);
		terrainContainer.add(generatedTerrain);
	}

	function createGroundPhysics(row:UInt, col:UInt, ground:Array<FlxPoint>):Void
	{
		groundBodies = [];

		var filter:InteractionFilter = new InteractionFilter();
		filter.collisionGroup = CPhysicsValue.GROUND_FILTER_CATEGORY;
		filter.collisionMask = CPhysicsValue.GROUND_FILTER_MASK;

		var groundCopy:Array<FlxPoint> = [];
		for (point in ground)
			groundCopy.push(new FlxPoint(point.x, point.y));
		groundCopy.push(new FlxPoint(ground[0].x, ground[0].y));

		for (point in groundCopy)
		{
			point.x += row * AppConfig.WORLD_PIECE_SIZE.x;
			point.y += col * AppConfig.WORLD_PIECE_SIZE.y;
		}

		for (i in 0...groundCopy.length - 1)
		{
			var angle:Float = Math.atan2(groundCopy[ i + 1 ].y - groundCopy[ i ].y, groundCopy[ i + 1 ].x - groundCopy[ i ].x);
			var distance:Float = Math.sqrt(
				Math.pow(Math.abs(groundCopy[ i + 1 ].x - groundCopy[ i ].x), 2) +
				Math.pow(Math.abs(groundCopy[ i + 1 ].y - groundCopy[ i ].y), 2)
			);

			var body:Body = new Body(BodyType.STATIC);

			body.shapes.add(new Polygon(Polygon.box(distance, 1)));
			body.setShapeMaterials(CPhysicsValue.MATERIAL_NORMAL_GROUND);
			body.setShapeFilters(filter);
			body.position.x = groundCopy[ i ].x + (groundCopy[ i + 1 ].x - groundCopy[ i ].x) / 2;
			body.position.y = groundCopy[ i ].y + (groundCopy[ i + 1 ].y - groundCopy[ i ].y) / 2;
			body.rotation = angle;

			body.space = space;

			groundBodies.push(body);
		}
	}

	function createBridges():Void
	{
		bridgeBodies = [];
		bridgeBlocks = [];

		var index:UInt = 0;
		for (i in 0...levelData.bridgePoints.length)
		{
			createBridge(
				new FlxPoint(levelData.bridgePoints[i].bridgeAX, levelData.bridgePoints[i].bridgeAY),
				new FlxPoint(levelData.bridgePoints[i].bridgeBX, levelData.bridgePoints[i].bridgeBY)
			);
		}
	}

	function createBridge(pointA:FlxPoint, pointB:FlxPoint):Void
	{
		var filter:InteractionFilter = new InteractionFilter();
		filter.collisionGroup = CPhysicsValue.BRIDGE_FILTER_CATEGORY;
		filter.collisionMask = CPhysicsValue.BRIDGE_FILTER_MASK;

		var bridgeAngle:Float = Math.atan2(pointB.y - pointA.y, pointB.x - pointA.x);
		var bridgeElementWidth:UInt = 60;
		var bridgeElementHeight:UInt = 25;
		var anchorA:Vec2 = new Vec2(bridgeElementWidth / 2, 0);
		var anchorB:Vec2 = new Vec2(-bridgeElementWidth / 2, 0);
		var bridgeDistance:Float = pointA.distanceTo(pointB);
		var pieces:UInt = Math.round(bridgeDistance / bridgeElementWidth) + 1;

		if (bridgeDistance % bridgeElementWidth == 0)
		{
			pieces++;
		}

		bridgeBlocks.push([]);
		bridgeBodies.push([]);

		for (i in 0...pieces)
		{
			var isLockedBridgeElement:Bool = false;
			if (i == 0 || i == cast(pieces - 1))
			{
				isLockedBridgeElement = true;
			}

			var body:Body = new Body(isLockedBridgeElement ? BodyType.STATIC : BodyType.DYNAMIC);
			body.shapes.add(new Polygon(Polygon.box(bridgeElementWidth, bridgeElementHeight)));
			body.setShapeMaterials(CPhysicsValue.MATERIAL_BRIDGE);
			body.setShapeFilters(filter);
			body.allowRotation = !isLockedBridgeElement;
			body.position.x = pointA.x + i * bridgeElementWidth * Math.cos(bridgeAngle);
			body.position.y = pointA.y + i * bridgeElementWidth * Math.sin(bridgeAngle);
			body.rotation = bridgeAngle;
			body.space = space;
			bridgeBodies[bridgeBodies.length - 1].push(body);

			var bridgeBlock:FlxSprite = HPPAssetManager.getSprite("bridge");
			container.add(bridgeBlock);
			bridgeBlocks[bridgeBlocks.length - 1].push(bridgeBlock);

			if (i > 0)
			{
				var pivotJointLeftLeftWheel:PivotJoint = new PivotJoint(bridgeBodies[bridgeBodies.length - 1][i - 1], bridgeBodies[bridgeBodies.length - 1][i], anchorA, anchorB);
				pivotJointLeftLeftWheel.damping = 1;
				pivotJointLeftLeftWheel.frequency = 20;
				pivotJointLeftLeftWheel.space = space;
			}
		}
	}

	function createOpponentCars():Void
	{
		if (replayDatas != null)
		{
			opponents = [];

			for (i in 0...replayDatas.length)
			{
				var id:UInt = Math.floor(Math.random() * 6) + 2;
				var opponent = new OpponentCar(CarDatas.getData(id), CAR_SCALE);
				opponents.push(opponent);
				container.add(opponent);
			}
		}
	}

	function createCar():Void
	{
		car = new Car(space, levelData.startPoint.x, levelData.startPoint.y, CarDatas.getData(SavedDataUtil.getPlayerInfo().selectedCar), CAR_SCALE, CPhysicsValue.CAR_FILTER_CATEGORY, CPhysicsValue.CAR_FILTER_MASK);
		container.add(car);
	}

	function createStaticElements():Void
	{
		staticElements = [];

		if (levelData.staticElementData != null)
		{
			for (element in levelData.staticElementData)
			{
				var selectedObject:FlxSprite = HPPAssetManager.getSprite(element.elementId);

				selectedObject.setPosition(element.position.x, element.position.y);
				selectedObject.origin.set(element.pivotX, element.pivotY);
				selectedObject.scale.set(element.scaleX, element.scaleY);
				selectedObject.angle = element.rotation;

				container.add(selectedObject);
				staticElements.push(selectedObject);
			}
		}
	}

	function createCoins():Void
	{
		coins = [];

		container.add(coinContainer = new FlxSpriteGroup());

		for (i in 0...levelData.collectableItems.length)
		{
			coins.push(cast coinContainer.add(new Coin(levelData.collectableItems[ i ].x, levelData.collectableItems[ i ].y)));
		}
	}

	function createSmallRocks():Void
	{
		smallRocks = [];
		usedSmallRocks = [];

		for (i in 0...30)
		{
			var smallRock:SmallRock = new SmallRock("small_rock_0_" + Math.floor(Math.random() * 2 + 1), releaseSmallRock);
			container.add(smallRock);
			smallRocks.push(smallRock);
		}
	}

	function releaseSmallRock(target:SmallRock):Void
	{
		smallRocks.push(target);
		usedSmallRocks.remove(target);
	}

	function createCarFogs():Void
	{
		carFogs = [];
		usedCarFogs = [];

		for (i in 0...20)
		{
			var carFog:CarFog = new CarFog("car_fog", releaseCarFog);
			container.add(carFog);
			carFogs.push(carFog);
		}
	}

	function releaseCarFog(target:CarFog):Void
	{
		carFogs.push(target);
		usedCarFogs.remove(target);
	}

	function createLibraryElements():Void
	{
		if (levelData.libraryElements != null)
		{
			container.add(libraryElementContainer = new FlxSpriteGroup());

			for(i in 0...levelData.libraryElements.length)
			{
				var libraryElement:LibraryElement = levelData.libraryElements[ i ];
				var crate:AbstractCrate;

				switch(libraryElement.className)
				{
					case CLibraryElement.CRATE_0:
						crate = new SmallCrate(space, libraryElement.x, libraryElement.y, libraryElement.scale);
						libraryElementContainer.add(crate);
						crates.push(crate);

					case CLibraryElement.CRATE_1:
						crate = new Crate(space, libraryElement.x, libraryElement.y, libraryElement.scale);
						libraryElementContainer.add(crate);
						crates.push(crate);

					case CLibraryElement.CRATE_2:
						crate = new LongCrate(space, libraryElement.x, libraryElement.y, libraryElement.scale);
						libraryElementContainer.add(crate);
						crates.push(crate);

					case CLibraryElement.CRATE_3:
						crate = new SmallLongCrate(space, libraryElement.x, libraryElement.y, libraryElement.scale);
						libraryElementContainer.add(crate);
						crates.push(crate);

					case CLibraryElement.CRATE_4:
						crate = new RampCrate(space, libraryElement.x, libraryElement.y, libraryElement.scale);
						libraryElementContainer.add(crate);
						crates.push(crate);

					case CLibraryElement.CRATE_5:
						crate = new SmallRampCrate(space, libraryElement.x, libraryElement.y, libraryElement.scale);
						libraryElementContainer.add(crate);
						crates.push(crate);
				}
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		now = Date.now().getTime();

		super.update(elapsed);

		for (polygon in polygonBackgrounds) polygon.updateView({ x: Std.int(camera.target.x), y: Std.int(camera.target.y) });

		if (carMarker != null && carMarker.visible) carMarker.y = car.carBodyPhysics.position.y - 55;

		if (isPhysicsEnabled)
		{
			space.step(CPhysicsValue.STEP);
		}

		if (car != null) car.isHorizontalMoveDisabled = isGamePaused && !isRaceStarted;

		if (isGamePaused || !isBuilt)
		{
			return;
		}

		calculateGameTime();

		if (!isLost && !isWon)
		{
			calculatePosition();

			gameGui.updateRemainingTime(Math.max(0, CGameTimeValue.MAXIMUM_GAME_TIME - gameTime));
			gameGui.updateCoinCount(collectedCoin);

			up = FlxG.keys.anyPressed([UP, W]) || gameGui.controlUpState;
			down = FlxG.keys.anyPressed([DOWN, S]) || gameGui.controlDownState;
			right = FlxG.keys.anyPressed([RIGHT, D]) || gameGui.controlRightState;
			left = FlxG.keys.anyPressed([LEFT, A]) || gameGui.controlLeftState;
		}
		else
		{
			up = down = right = left = false;
		}

		if (up) car.accelerateToRight();
		else if (down) car.accelerateToLeft();
		else car.idle();

		if (right)
		{
			car.rotateRight();
		}
		else if (left)
		{
			car.rotateLeft();
		}

		updateBridges();

		if (AppConfig.IS_DESKTOP_DEVICE)
		{
			updateSmallRocks();
			updateCarFogs();
		}

		if (!isLost)
		{
			checkCoinPickUp();
			checkWheelieState();
			checkFlipState();
			checkLoose();
			checkWin();

			if (AppConfig.IS_DESKTOP_DEVICE && (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.P))
				pauseRequest(null);
		}

		if (playbacks != null)
			for (playback in playbacks) playback.showSnapshot(gameTime);
	}

	function calculateGameTime():Void
	{
		if (isGameStarted)
		{
			gameTime = now - gameStartTime - totalPausedTime;
		}
		else
		{
			gameTime = 0;
		}
	}

	function updateBridges():Void
	{
		for (i in 0...bridgeBlocks.length)
		{
			for (j in 0...bridgeBlocks[i].length)
			{
				var block:FlxSprite = bridgeBlocks[i][j];
				var body:Body = bridgeBodies[i][j];

				block.x = body.position.x - block.origin.x;
				block.y = body.position.y - block.origin.y;
				block.angle = body.rotation * FlxAngle.TO_DEG;
			}
		}
	}

	function updateSmallRocks():Void
	{
		var leftAngularVelocity:Float = Math.abs(car.wheelLeftPhysics.angularVel);
		var rightAngularVelocity:Float = Math.abs(car.wheelRightPhysics.angularVel);
		var carDirection:Int = car.wheelLeftPhysics.velocity.x >= 0 ? 1 : -1;

		if (!car.leftWheelOnAir && (up || down) && smallRocks.length > 0 && leftAngularVelocity > 5 && Math.random() > .8)
		{
			usedSmallRocks.push(smallRocks[ smallRocks.length - 1 ]);
			smallRocks.pop();

			var selectedSmallRock:SmallRock = usedSmallRocks[ usedSmallRocks.length - 1 ];
			selectedSmallRock.visible = true;
			selectedSmallRock.alpha = 1;
			selectedSmallRock.x = car.wheelLeftGraphics.x + car.wheelLeftGraphics.width / 2 + -carDirection * car.wheelLeftGraphics.width / 4;
			selectedSmallRock.y = car.wheelLeftGraphics.y + car.wheelLeftGraphics.height - selectedSmallRock.height;
			selectedSmallRock.startAnim(-carDirection, car.carBodyGraphics.angle * FlxAngle.TO_RAD);
		}

		if (!car.rightWheelOnAir && (up || down) && smallRocks.length > 0 && rightAngularVelocity > 5 && Math.random() > .8)
		{
			usedSmallRocks.push(smallRocks[ smallRocks.length - 1 ]);
			smallRocks.pop();

			var selectedSmallRock:SmallRock = usedSmallRocks[ usedSmallRocks.length - 1 ];
			selectedSmallRock.visible = true;
			selectedSmallRock.alpha = 1;
			selectedSmallRock.x = car.wheelRightGraphics.x + car.wheelRightGraphics.width / 2 + -carDirection * car.wheelRightGraphics.width / 4;
			selectedSmallRock.y = car.wheelRightGraphics.y + car.wheelRightGraphics.height - selectedSmallRock.height;
			selectedSmallRock.startAnim(-carDirection, car.carBodyGraphics.angle * FlxAngle.TO_RAD);
		}
	}

	function updateCarFogs():Void
	{
		if (Math.random() > .8)
		{
			usedCarFogs.push(carFogs[ carFogs.length - 1 ]);
			carFogs.pop();

			var carAngleInRad:Float = car.carBodyGraphics.angle * FlxAngle.TO_RAD;
			var selectedCarFog:CarFog = usedCarFogs[ usedCarFogs.length - 1 ];
			selectedCarFog.visible = true;
			selectedCarFog.alpha = 1;
			selectedCarFog.x = car.carBodyPhysics.position.x - 140 * car.carScale * Math.cos(carAngleInRad);
			selectedCarFog.y = car.carBodyPhysics.position.y - 140 * car.carScale * Math.sin(carAngleInRad);
			selectedCarFog.startAnim(carAngleInRad);
		}
	}

	function checkCoinPickUp():Void
	{
		var backWheelMidPoint:FlxPoint = car.wheelLeftGraphics.getMidpoint();
		var frontWheelMidPoint:FlxPoint = car.wheelRightGraphics.getMidpoint();

		for (i in 0...coins.length)
		{
			var coin:Coin = coins[ i ];
			var coinMidPoint:FlxPoint = coin.getMidpoint();

			if (
				!coin.isCollected
				&& (
					Point.distance(new Point(coinMidPoint.x, coinMidPoint.y), new Point(frontWheelMidPoint.x, frontWheelMidPoint.y)) < coin.width / 2 + car.wheelRightGraphics.width / 2 - 5
					|| Point.distance(new Point(coinMidPoint.x, coinMidPoint.y), new Point(backWheelMidPoint.x, backWheelMidPoint.y)) < coin.width / 2 + car.wheelLeftGraphics.width / 2 - 5
				)
			){
				coin.collect();
				collectedCoin++;
			}
		}
	}

	function checkWheelieState():Void
	{
		var isWheelieInProgress:Bool = (car.rightWheelOnAir && !car.leftWheelOnAir) || (!car.rightWheelOnAir && car.leftWheelOnAir);

		if(!isWheelieInProgress && car.isOnWheelie && gameTime - car.onWheelieStartGameTime > CGameTimeValue.MINIMUM_TIME_TO_NICE_WHEELIE_IN_MS)
		{
			startNiceWheelieTimeRutin();
		}

		if(isWheelieInProgress && !car.isOnWheelie)
		{
			car.onWheelieStartGameTime = gameTime;
		}

		car.isOnWheelie = isWheelieInProgress;
	}

	function checkFlipState():Void
	{
		var newIsOnAirValue:Bool = car.leftWheelOnAir && car.rightWheelOnAir;

		if(car.leftWheelOnAir && car.rightWheelOnAir)
		{
			var currentAngle:Float = Math.atan2(car.wheelLeftGraphics.y - car.wheelRightGraphics.y, car.wheelLeftGraphics.x - car.wheelRightGraphics.x);
			currentAngle = car.wheelLeftGraphics.x - car.wheelRightGraphics.x < 0 ? (Math.PI * 2 + currentAngle) : currentAngle;

			while(currentAngle > Math.PI * 2)
			{
				currentAngle -= Math.PI * 2;
			}

			if(!car.isOnAir)
			{
				car.onAirStartGameTime = gameTime;
				car.isOnAir = true;
				car.jumpAngle = 0;
				car.lastAngleOnGround = currentAngle;
			}

			var angleDiff:Float = currentAngle - car.lastAngleOnGround;

			if(angleDiff < -Math.PI)
			{
				angleDiff += Math.PI * 2;
				angleDiff *= -1;
			}
			else if(angleDiff > Math.PI)
			{
				angleDiff -= Math.PI * 2;
				angleDiff *= -1;
			}

			car.lastAngleOnGround = currentAngle;
			car.jumpAngle += angleDiff;
		}
		else if(car.isOnAir)
		{
			var angleInDeg:Float = car.jumpAngle * (180 / Math.PI);

			car.isOnAir = false;
			car.jumpAngle = 0;
			car.lastAngleOnGround = 0;

			if(angleInDeg > 200)
			{
				startFrontFlipRutin();
			}
			else if(angleInDeg < -200)
			{
				startBackFlipRutin();
			}
		}
	}

	function checkLoose():Void
	{
		var isTimeout:Bool = gameTime >= CGameTimeValue.MAXIMUM_GAME_TIME;
		var isFallDown:Bool = car.carBodyGraphics.y > levelData.cameraBounds.y + levelData.cameraBounds.height;

		if (!isLost && !isWon && (car.isCarCrashed || isTimeout || isFallDown))
		{
			isLost = true;

			if (car.isCarCrashed || isFallDown)
			{
				FlxG.sound.play("assets/sounds/crushed.ogg", AppConfig.SOUND_VOLUME);

				camera.shake(.02, .2);
				addEffect(car.carBodyGraphics.x - 30, car.carBodyGraphics.y - (isFallDown ? 100 : 20), GameEffect.TYPE_CRUSHED);
			}
			else
			{
				addEffect(car.carBodyGraphics.x - 30, car.carBodyGraphics.y - 20, GameEffect.TYPE_TIME_OUT);
			}

			rightFocusOnCar();

			Timer.delay(gameOverRutin, 1000);

			FlxG.sound.music.stop();
			engineSound.stop();
		}
	}

	function checkWin():Void
	{
		if (!isLost && !isWon && car.carBodyGraphics.x >= levelData.finishPoint.x && car.carBodyGraphics.y > levelData.finishPoint.y - 300 && car.carBodyGraphics.y < levelData.finishPoint.y + 300)
		//if (!isLost && !isWon && gameTime > 2000) // temporary for instant win
		{
			FlxG.sound.play("assets/sounds/won.ogg", AppConfig.SOUND_VOLUME);

			isWon = true;
			isLevelFinished = true;

			addEffect(car.carBodyGraphics.x - 30, car.carBodyGraphics.y - 20, GameEffect.TYPE_LEVEL_COMPLETED);

			rightFocusOnCar();

			Timer.delay(gameOverRutin, 250);

			FlxG.sound.music.stop();
			engineSound.stop();
		}
	}

	function rightFocusOnCar()
	{
		var w:Float = camera.width / 8;
		camera.deadzone.x = (camera.width + w * 5) / 2;
	}

	function gameOverRutin():Void
	{
		engineSound.stop();
		//recorder.takeSnapshot();

		if (worldId == 2)
		{
			isWon = isWon && collectedCoin == levelData.collectableItems.length;
			isLost = !isWon;
		}

		var nextLevelInfo:LevelSavedData;
		var isNewLevelUnlocked:Bool = false;

		if (isWon && playerPosition == 1)
		{
			if (levelId < 4)
			{
				nextLevelInfo = SavedDataUtil.getLevelInfo(worldId, levelId + 1);
				if (!nextLevelInfo.isEnabled) isNewLevelUnlocked = true;
				nextLevelInfo.isEnabled = true;
			}
			if (levelId == 4 && worldId == 0)
			{
				nextLevelInfo = SavedDataUtil.getLevelInfo(worldId + 1, 0);
				if (!nextLevelInfo.isEnabled) isNewLevelUnlocked = true;
				nextLevelInfo.isEnabled = true;
			}
		}

		var levelEndData = new LevelEndData();
		levelEndData.isUnlockedNextLevel = isNewLevelUnlocked;
		levelEndData.gameTime = gameTime;
		levelEndData.position = playerPosition;
		levelEndData.collectedCoin = collectedCoin;
		levelEndData.isAllCoinCollected = collectedCoin == levelData.collectableItems.length;
		levelEndData.countOfFrontFlip = countOfFrontFlip;
		levelEndData.countOfBackFlip = countOfBackFlip;
		levelEndData.countOfNiceWheelie = countOfNiceWheelie;
		levelEndData.totalScore = isWon ? ScoreUtil.calculateTotalScore(levelEndData) : 0;
		levelEndData.isHighscore = isWon ? levelEndData.totalScore > levelInfo.score : false;
		levelEndData.starCount = isWon ? ScoreUtil.scoreToStarCount(levelEndData.totalScore, levelData.starValues) : 0;
		levelEndData.isLevelFinished = isLevelFinished;
		levelEndData.isWon = isWon;

		// Temporary for save base replays
		//trace(recorder.toString());

		levelInfo.time = (isWon && (levelInfo.time > gameTime || levelInfo.time == 0)) ? gameTime : levelInfo.time;
		levelInfo.score = (isWon && (levelInfo.score < levelEndData.totalScore)) ? levelEndData.totalScore : levelInfo.score;
		levelInfo.isCompleted = (isWon && levelEndData.position == 1) ? true : levelInfo.isCompleted;
		levelInfo.starCount = levelInfo.starCount < levelEndData.starCount ? levelEndData.starCount : levelInfo.starCount;
		levelInfo.collectedCoins = levelInfo.collectedCoins < collectedCoin ? collectedCoin : levelInfo.collectedCoins;

		SavedDataUtil.getPlayerInfo().coin += levelEndData.totalCollectedCoin;

		persistentUpdate = false;
		openSubState(endLevelPanel);
		endLevelPanel.updateView(levelEndData);
		gameGui.visible = false;

		SavedDataUtil.save();
	}

	function calculatePosition():Void
	{
		var position:UInt = 1;

		for (opponent in opponents)
			if (opponent.carBodyGraphics.x > car.carBodyGraphics.x)
				position++;

		playerPosition = position;
	}

	function startFrontFlipRutin():Void
	{
		countOfFrontFlip++;

		gameGui.updateFrontFlipCount(countOfFrontFlip);
		gameGui.addNotification(Notification.FRONT_FLIP);
	}

	function startBackFlipRutin():Void
	{
		countOfBackFlip++;

		gameGui.updateBackFlipCount(countOfBackFlip);
		gameGui.addNotification(Notification.BACK_FLIP);
	}

	function startNiceWheelieTimeRutin():Void
	{
		countOfNiceWheelie++;

		gameGui.updateWheelieCount(countOfNiceWheelie);
		gameGui.addNotification(Notification.NICE_WHEELIE);
	}

	function addEffect(x:Float, y:Float, effectType:GameEffect):Void
	{
		var effect:FlxSprite = HPPAssetManager.getSprite(cast effectType);

		effect.origin.set(effect.width / 2, effect.height / 2);
		effect.x = x;
		effect.y = y;
		effect.scale.set(.5, .5);
		effect.alpha = AppConfig.IS_ALPHA_ANIMATION_ENABLED ? 0 : 1;

		if (AppConfig.IS_ALPHA_ANIMATION_ENABLED)
		{
			FlxTween.tween(
				effect,
				{ alpha: 1 },
				.5
			);
			FlxTween.tween(
				effect,
				{ alpha: 0 },
				.3,
				{ startDelay: 1 }
			);
		}

		FlxTween.tween(
			effect.scale,
			{
				x: 1,
				y: 1,
			},
			.3,
			{ ease: FlxEase.backOut }
		);

		FlxTween.tween(
			effect.scale,
			{
				x: .3,
				y: .3,
			},
			.2,
			{ ease: FlxEase.backIn, startDelay: 1, onComplete: function(_) { disposeEffect(effect); } }
		);

		container.add(effect);
		effects.push(effect);
	}

	function disposeEffect(target:FlxSprite):Void
	{
		for (effect in effects)
		{
			if (effect == target)
			{
				effects.remove(effect);
				effect.destroy();
				effect = null;

				return;
			}
		}
	}

	function restartRutin():Void
	{
		reset();
	}

	function restartRequest(target:HPPButton = null):Void
	{
		restartRutin();
	}

	function exitRequest(target:HPPButton = null):Void
	{
		FlxG.switchState(new MenuState(MenuSubStateType.LEVEL_SELECTOR, {worldId: worldId}));
	}

	function nextLevelRequest(target:HPPButton = null):Void
	{
		FlxG.switchState(new GameState(worldId, levelId + 1));
	}

	function prevLevelRequest(target:HPPButton = null):Void
	{
		FlxG.switchState(new GameState(worldId, levelId - 1));
	}

	override public function onFocusLost():Void
	{
		if (isGameStarted)
		{
			pauseRequest();
		}

		super.onFocusLost();
	}

	override public function destroy():Void
	{
		HPPAssetManager.clear();

		FlxG.sound.music.stop();
		engineSound.stop();

		super.destroy();
	}
}

@:enum
abstract GameEffect(String)
{
	var TYPE_LEVEL_COMPLETED = "effect_level_completed";
	var TYPE_CRUSHED = "effect_crushed";
	var TYPE_TIME_OUT = "effect_time_out";
}