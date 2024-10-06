package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.PlayState;
import backend.CustomFlxSoundTray;

class Main extends Sprite
{
	var config = {
		width: 1280, // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
		height: 720, // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
		zoom: -1.0, // If -1, zoom is automatically calculated to fit the window dimensions. (Removed from Flixel 5.0.0)
		framerate: 60, // How many frames per second the game should run at.
		initialState: PlayState, // is the state in which the game will start.
		skipSplash: false, // Whether to skip the flixel splash screen that appears in release mode.
		startFullscreen: false // Whether to start the game in fullscreen on desktop targets
	};

	// You can pretty much ignore everything from here on - your code should go in your states.

	public function new()
	{
		super();
		var game = new FlxGame(config.width, config.height, config.initialState, #if (flixel < "5.0.0") config.zoom, #end config.framerate, config.framerate,
			config.skipSplash, config.startFullscreen);

		// FlxG.game._customSoundTray wants just the class, it calls new from
		// create() in there, which gets called when it's added to stage
		// which is why it needs to be added before addChild(game) here
		@:privateAccess
		game._customSoundTray = CustomFlxSoundTray;

		addChild(game);
	}
}
