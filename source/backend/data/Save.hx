package backend.data;

import flixel.util.FlxSave;

class Save {
    public static var settings:Map<String, Dynamic> = [
        // name, value
        "FPS Counter" => true
	];

    public static function saveSettings() {
		var settingsSave:FlxSave = new FlxSave();
		settingsSave.bind('rore', 'huy1234th');
		settingsSave.data.settings = settings;
		settingsSave.close();

		trace("settings saved!");
	}

    public static function loadSettings() {
		var settingsSave:FlxSave = new FlxSave();
		settingsSave.bind('rore', 'huy1234th');

		if (settingsSave != null) {
			if (settingsSave.data.settings != null) {
				var savedMap:Map<String, Dynamic> = settingsSave.data.settings;
				for (name => value in savedMap) {
					settings.set(name, value);
				}
			}
		}

		settingsSave.destroy();
	}

	public static function get(string:String)
		return settings.get(string);
	
	public static function set(string:String, newValue:Dynamic)
		return settings.set(string, newValue);
}