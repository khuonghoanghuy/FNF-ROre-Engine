package shaders;

import flixel.addons.display.FlxRuntimeShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;

class BlendModesShader extends FlxRuntimeShader
{
  public var camera:ShaderInput<BitmapData>;
  public var cameraData:BitmapData;

  public function new()
  {
    super(Assets.getText(Paths.frag('blendModes')));
  }
}