package states;

import flixel.util.FlxColor;
import flixel.addons.ui.FlxUIState;
import flixel.FlxSpriteOverlay;
import flixel.FlxSprite;
import shaders.ColorSwap;
import backend.state.MusicBeatState;

class TitleState extends MusicBeatState
{
    var danceLeft:Bool = false;
    var titleText:FlxSprite;
    var logoBl:FlxSprite;
    var gfDance:FlxSpriteOverlay;
    var swagShader:ColorSwap;
    var transitioning:Bool = false;
    var initialized:Bool = false;
    var skippedIntro:Bool = false;

    override function create() {
        super.create();
        FlxG.sound.cache(Paths.music('freakyMenu/freakyMenu'));
        swagShader = new ColorSwap();
        if (!initialized) new FlxTimer().start(1, function(tmr:FlxTimer) {
            startIntro();
        });
        else
            startIntro();
    }

    function startIntro() {
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
        {
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
            FlxG.sound.music.fadeIn(4, 0, 0.7);
        }

        backend.data.Conductor.changeBPM(102);
        persistentUpdate = true;

        logoBl = new FlxSprite(-150, -100);
        logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
        logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
        logoBl.animation.play('bump');
        if (Save.get("shaders"))
            logoBl.shader = swagShader.shader;
        logoBl.updateHitbox();
        add(logoBl);

        gfDance = new FlxSpriteOverlay(FlxG.width * 0.4, FlxG.height * 0.07);
        gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
        gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
        gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
        if (Save.get("shaders"))
            gfDance.shader = swagShader.shader;
        add(gfDance);

        titleText = new FlxSprite(100, FlxG.height * 0.8);
        titleText.frames = Paths.getSparrowAtlas('titleEnter');
        titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
        titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
        titleText.animation.play('idle');
        titleText.updateHitbox();
        if (Save.get("shaders"))
            titleText.shader = swagShader.shader;
        add(titleText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        FlxG.bitmapLog.add(FlxG.camera.buffer);
        #if desktop
        if (FlxG.keys.justPressed.ESCAPE)
        {
            Sys.exit(0);
        }
        #end
        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;
        if (pressedEnter && !transitioning && skippedIntro)
        {
            if (FlxG.sound.music != null) FlxG.sound.music.onComplete = null;
            titleText.animation.play('press');
            FlxG.camera.flash(FlxColor.WHITE, 1);
            FlxG.sound.play(Paths.sound("confirmMenu"), 0.7);
            new FlxTimer().start(2, function(tmr:FlxTimer) {
                FlxG.switchState(new PlayState());
            });
        }
    }

    override function beatHit() {
        super.beatHit();

        danceLeft = !danceLeft;

        if (gfDance != null && gfDance.animation != null)
        {
            if (danceLeft) gfDance.animation.play('danceRight');
            else gfDance.animation.play('danceLeft');
        }

        if (curBeat % 4 == 0)
            logoBl.animation.play("bump");
    }
}