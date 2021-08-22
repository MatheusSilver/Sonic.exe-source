package;

import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
    var ezbg:FlxSprite;

    var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

    var curdiff:Int = 2;

    var oneclickpls:Bool = true;

    var bfIDLELAWL:StoryModeMenuBFidle;

    var redBOX:FlxSprite;

 
    override function create()
    {

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('storymodemenumusic'));
		}

        FlxG.sound.playMusic(Paths.music('storymodemenumusic'));
        
        var bg:FlxSprite;
		
		bg = new FlxSprite(0, 0);
		bg.frames = Paths.getSparrowAtlas('SMMStatic', 'exe');
		bg.animation.addByPrefix('idlexd', "damfstatic", 24);
		bg.animation.play('idlexd');
		bg.alpha = 1;
		bg.antialiasing = false;
		bg.setGraphicSize(Std.int(bg.width));
		bg.updateHitbox();
		add(bg);




        var greyBOX:FlxSprite;
		greyBOX = new FlxSprite(0,0).loadGraphic(Paths.image('greybox'));
		bg.alpha = 1;
		greyBOX.antialiasing = false;
		greyBOX.setGraphicSize(Std.int(bg.width));
		greyBOX.updateHitbox();
		add(greyBOX);


        bfIDLELAWL = new StoryModeMenuBFidle(0,0);
		bfIDLELAWL.scale.x = .4;
		bfIDLELAWL.scale.y = .4;
		bfIDLELAWL.screenCenter();
		bfIDLELAWL.y += 50;
		bfIDLELAWL.antialiasing = false;
		bfIDLELAWL.animation.play('idleLAWLAW', true);
		add(bfIDLELAWL);

        var staticscreen:FlxSprite;
        staticscreen = new FlxSprite(450, 0);
		staticscreen.frames = Paths.getSparrowAtlas('screenstatic', 'exe');
		staticscreen.animation.addByPrefix('screenstaticANIM', "screenSTATIC", 24);
		staticscreen.animation.play('screenstaticANIM');
        staticscreen.y += 79;
		staticscreen.alpha = 1;
		staticscreen.antialiasing = false;
		staticscreen.setGraphicSize(Std.int(staticscreen.width * 0.275));
		staticscreen.updateHitbox();
		add(staticscreen);


        var yellowBOX:FlxSprite;
		yellowBOX = new FlxSprite(0,0).loadGraphic(Paths.image('yellowbox'));
		yellowBOX.alpha = 1;
		yellowBOX.antialiasing = false;
		yellowBOX.setGraphicSize(Std.int(bg.width));
		yellowBOX.updateHitbox();
		add(yellowBOX);

        
		redBOX = new FlxSprite(0,0).loadGraphic(Paths.image('redbox'));
		redBOX.alpha = 1;
		redBOX.antialiasing = false;
		redBOX.setGraphicSize(Std.int(bg.width));
		redBOX.updateHitbox();
		add(redBOX);




        sprDifficulty = new FlxSprite(550, 600);
        sprDifficulty.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
        sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('normal');
        add(sprDifficulty);

        leftArrow = new FlxSprite(sprDifficulty.x - 150, sprDifficulty.y);
        leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
        leftArrow.setGraphicSize(Std.int(leftArrow.width * 0.8));
        leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
        add(leftArrow);

        rightArrow = new FlxSprite(sprDifficulty.x + 230, sprDifficulty.y);
        rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
        rightArrow.setGraphicSize(Std.int(rightArrow.width * 0.8));
        rightArrow.animation.addByPrefix('idle', "arrow right");
		rightArrow.animation.addByPrefix('press', "arrow push right");
		rightArrow.animation.play('idle');
        add(rightArrow);

        sprDifficulty.offset.x = 70;
        sprDifficulty.y = leftArrow.y + 10;

		addVirtualPad(UP_DOWN, A_B);


        super.create();
    }


    function changediff(diff:Int = 1)
    {
        curdiff += diff;

        if (curdiff == 0) curdiff = 3;
        if (curdiff == 4) curdiff = 1;
        
        FlxG.sound.play(Paths.sound('scrollMenu'));

        switch (curdiff)
        {
            case 1:
                sprDifficulty.animation.play('easy');
                sprDifficulty.offset.x = 20;
            case 2:
                sprDifficulty.animation.play('normal');
                sprDifficulty.offset.x = 70;
            case 3:
                sprDifficulty.animation.play('hard');
                sprDifficulty.offset.x = 20;
        }
        sprDifficulty.alpha = 0;
        sprDifficulty.y = leftArrow.y - 15;    
        FlxTween.tween(sprDifficulty, {y: leftArrow.y + 10, alpha: 1}, 0.07);
    }

    override public function update(elapsed:Float)
    {
        if (controls.UP_P) changediff(-1);

        if (controls.DOWN_P) changediff(1);

        if (controls.BACK)
		{
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function(){
						FlxG.switchState(new MainMenuState()); // Copiei e colei por que sim!!! e foudase
				});
			});
		}

        if (controls.ACCEPT)
        {
            if (oneclickpls)
            {

                oneclickpls = false;
                var curDifficulty = '';

                FlxG.sound.play(Paths.sound('confirmMenu'));
                PlayState.storyPlaylist = ['too-slow'];
                PlayState.isStoryMode = true;
                switch(curdiff)
                {
                    case 1:
                        curDifficulty = '-easy';
                    case 3:
                        curDifficulty = '-hard';
                }

                curdiff -= 1;
                PlayState.storyDifficulty = curdiff;

                PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + curDifficulty, PlayState.storyPlaylist[0].toLowerCase());
                PlayState.storyWeek = 1;
                PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function(){
						LoadingState.loadAndSwitchState(new VideoState('assets/videos/tooslowcutscene1', new PlayState())); 
				});
			});
                
            }


            if (FlxG.save.data.flashing)
                {
                    FlxFlicker.flicker(redBOX, 1, 0.06, false, false, function(flick:FlxFlicker)
                    {
                     
                    });
                }
        }

        super.update(elapsed);
    }
}