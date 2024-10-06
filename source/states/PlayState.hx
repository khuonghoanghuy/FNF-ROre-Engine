package states;

import backend.state.MusicBeatState;
import flixel.FlxState;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;
	var scriptArray:Array<HScript> = [];

	public function new() {
		super();
		instance = this;
	}

	override public function create()
	{
		#if allow_hscript
		for (script in LimeAssets.list(TEXT).filter(text -> text.contains('assets/scripts')))
			if (script.endsWith('.hx'))
				scriptArray.push(new HScript(script));
		#end

		callOnScripts("create", []);

		super.create();

		callOnScripts("createPost", []);

		#if allow_hscript
		if (LimeAssets.exists(Paths.script('data/scripts/script')))
			scriptArray.push(new HScript(Paths.script('data/scripts/script')));
		#end
	}

	override public function update(elapsed:Float)
	{
		callOnScripts("update", [elapsed]);

		super.update(elapsed);

		callOnScripts("updatePost", [elapsed]);
	}

	override function destroy() {
		super.destroy();
		callOnScripts("destroy", []);
		instance = null;
		scriptArray = [];
	}

	private function callOnScripts(funcName:String, args:Array<Dynamic>):Dynamic {
		var value:Dynamic = HScript.Function_Continue;
		for (i in 0...scriptArray.length) {
			final call:Dynamic = scriptArray[i].executeFunc(funcName, args);
			final bool:Bool = call == HScript.Function_Continue;
			if (!bool && call != null)
				value = call;
		}
		return value;
	}
}
