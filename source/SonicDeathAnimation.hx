package;

import flixel.addons.effects.FlxTrail;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class SonicDeathAnimation extends FlxSprite
{
    public var exeanimOffsets:Map<String, Array<Dynamic>>;
	public var exedebugMode:Bool = false;

	public var execurCharacter:String = 'sonicdeath';

	public var exeholdTimer:Float = 0;

    public function new(x:Float, y:Float)
        {
            super(x, y);

            exeanimOffsets = new Map<String, Array<Dynamic>>();


            var tex:FlxAtlasFrames;
            antialiasing = false;

            tex = Paths.getSparrowAtlas('characters/DeathScreenSonicExe');
			frames = tex;
			animation.addByPrefix('firstDEATH', 'appear', 24, false);
			animation.addByPrefix('loopDEATH', 'deathLoopSonicExe', 24, true);
            animation.addByPrefix('retry', 'deathConfirmSonicExe', 24, false);

            addOffset('firstDEATH', 0, 0);
            addOffset('loopDEATH', -25, -80);
            addOffset('retry', -32,-127);
        }

        public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
            {
                animation.play(AnimName, Force, Reversed, Frame);
        
                var daOffset = exeanimOffsets.get(AnimName);
                if (exeanimOffsets.exists(AnimName))
                {
                    offset.set(daOffset[0], daOffset[1]);
                }
                else
                    offset.set(0, 0);
        
                
            }

            public function addOffset(name:String, x:Float = 0, y:Float = 0)
                {
                    exeanimOffsets[name] = [x, y];
                }
        
        override function update(elapsed:Float)
            {

                if (animation.curAnim.name == 'firstDEATH' && animation.curAnim.finished)
                    {
                        playAnim('loopDEATH');
        
                    }

                if (animation.curAnim.name == 'retry' && animation.curAnim.finished)
                    {
                        visible = false;
        
                    }


                super.update(elapsed);
            }
            
}