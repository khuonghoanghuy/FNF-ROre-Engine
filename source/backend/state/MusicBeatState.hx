package backend.state;

import backend.data.Save;
import flixel.system.FlxAssets.FlxShader;
import flixel.FlxObject;
import backend.data.Conductor;
import backend.data.PlayerSettings;
import backend.data.Controls;
import flixel.FlxBasic;
import backend.data.Conductor.BPMChangeEvent;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Int = 0;
	private var lastStep:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	public var controls(get, never):Controls;
    public var save:Save;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}