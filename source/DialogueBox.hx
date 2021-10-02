package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var ending:Bool = false;
	var skipText:FlxText;
	var imPRESSED:Bool = false;
	var holdShit:Float = .5;
	var canInput:Bool = true;
	var stopSound:Bool = false;
	var funnySound:FlxSound;

	var box:FlxSprite;
	var bottomImage:FlxSprite;
	var topImage:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	var titleText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitMiddle:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var portTween:FlxTween;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFFFFFFF);
		bgFade.scrollFactor.set();
		bgFade.alpha = .2;
		add(bgFade);

		bottomImage = new FlxSprite(0, 0);
		bottomImage.visible = false;
		add(bottomImage);

		box = new FlxSprite(0, 0);
		//box.scale.set(.9, .9);
		
		var hasDialog = false;

		hasDialog = true;
		//box.frames = Paths.getSparrowAtlas('arctic/dialogue/box', 'shared');
	//	box.animation.addByPrefix('normalOpen', 'box', 24, false);
		//box.animation.addByIndices('normal', 'box', [4], "", 24);

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-275, 318);
/* 		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9)); */
		portraitLeft.scale.set(.5, .5);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(700, 125);
/* 		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9)); */
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitMiddle = new FlxSprite(375, 90);
/* 		portraitMiddle.frames = Paths.getSparrowAtlas('weeb/gf');
		portraitMiddle.animation.addByPrefix('enter', 'Girlfriend portrait enter', 24, false);
		portraitMiddle.setGraphicSize(Std.int(portraitRight.width * 1)); */
		portraitMiddle.updateHitbox();
		portraitMiddle.scrollFactor.set();
		add(portraitMiddle);
		portraitMiddle.visible = false;
		
		box.loadGraphic(Paths.image('arctic/dialogue/finalbox', 'shared'));
		//box.setGraphicSize(Std.int(box.width * 1));
		box.updateHitbox();
		add(box);

		add(portraitLeft);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		//add(handSelect);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 525, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = Paths.font("vcr.ttf");
		dropText.color = 0xFFD89494;
		//add(dropText);

		swagDialogue = new FlxTypeText(225, 450, Std.int(FlxG.width * 0.6), "", 25);
		swagDialogue.font = Paths.font("generis.ttf");
		swagDialogue.color = FlxColor.WHITE;
		swagDialogue.borderColor = FlxColor.BLACK;
		swagDialogue.borderStyle = OUTLINE;
		swagDialogue.borderSize = 2;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		titleText = new FlxText(10, 375, Std.int(FlxG.width * 0.6), "", 29);
		titleText.font = Paths.font("generis.ttf");
		titleText.color = FlxColor.WHITE;
		titleText.borderColor = FlxColor.BLACK;
		titleText.borderStyle = OUTLINE;
		titleText.borderSize = 2;
		add(titleText);

		topImage = new FlxSprite(0, 0);
		topImage.visible = false;
		add(topImage);

		skipText = new FlxText(10, 680, 0, "Hold [SHIFT] to skip dialogue]", 22);
		skipText.screenCenter(X);
		skipText.x += 50;
		skipText.font = Paths.font("vcr.ttf");
		skipText.color = FlxColor.WHITE;
		skipText.borderColor = FlxColor.BLACK;
		skipText.borderStyle = OUTLINE;
		skipText.borderSize = 2;
		add(skipText);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = true;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		//box.animation.play('normal');

/* 		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		} */

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true && canInput)
		{
			addDialogue();
		}

		if (FlxG.keys.pressed.SHIFT && !ending)
			{
				holdShit += 0.005;
				imPRESSED = true;

				if (holdShit >= 1)
					{
						ending = true;
						PlayState.instance.camHUD.flash(FlxColor.WHITE, .5);
						endIt();
					}
			}
		else if (imPRESSED = true)
			{
				holdShit = .5;
				imPRESSED = false;
			}

		skipText.alpha = holdShit;
		
		super.update(elapsed);
	}

	function addDialogue(playSound:Bool = true)
		{
				remove(dialogue);
				
				if (playSound)
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
		
				if (dialogueList[1] == null && dialogueList[0] != null)
					{
						if (!isEnding)
						{
							isEnding = true;
		
							FlxG.sound.music.fadeOut(1, 0);
		
/* 							new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								box.alpha -= 1 / 5;
								bgFade.alpha -= 1 / 5 * 0.7;
								portraitLeft.visible = false;
								portraitRight.visible = false;
								portraitMiddle.visible = false;
								swagDialogue.alpha -= 1 / 5;
								dropText.alpha = swagDialogue.alpha;
								titleText.alpha = swagDialogue.alpha;
							}, 5); */

							FlxTween.tween(box, {y: 1000}, 1, {ease: FlxEase.quartIn});
							FlxTween.tween(titleText, {y: 1375}, 1, {ease: FlxEase.quartIn});
							FlxTween.tween(swagDialogue, {y: 1450}, 1, {ease: FlxEase.quartIn});
							FlxTween.tween(portraitLeft, {y: 1318}, 1, {ease: FlxEase.quartIn});
							FlxTween.tween(bgFade, {alpha: 0}, 1, {ease: FlxEase.quartIn});
							FlxTween.tween(bottomImage, {alpha: 0}, 1, {ease: FlxEase.quartIn});
							portraitRight.visible = false;
							portraitMiddle.visible = false;

							new FlxTimer().start(1.2, function(tmr:FlxTimer)
							{
								finishThing();
								kill();
							});
						}
					}
				else
					{
						dialogueList.remove(dialogueList[0]);
						startDialogue();
					}
		}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		if (portTween != null)
			portTween.cancel;

		portraitLeft.x = -275;

		portTween = FlxTween.tween(portraitLeft, {x: -150}, .75, {ease: FlxEase.quartOut});

		switch (curCharacter)
		{
			//DIALOGUE PORTRAITS

			//LEFT SIDE
			case 'max':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				titleText.text = "Max";
				titleText.color = 0xffb412;
				titleText.borderColor = 0xFF6f4906;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.loadGraphic(Paths.image('arctic/dialogue/max', 'shared'));
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
					}
			case 'maxsmile':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				titleText.text = "Max";
				titleText.color = 0xffb412;
				titleText.borderColor = 0xFF6f4906;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.loadGraphic(Paths.image('arctic/dialogue/maxsmile', 'shared'));
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
					}
			case 'maxsuprise':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				titleText.text = "Max";
				titleText.color = 0xffb412;
				titleText.borderColor = 0xFF6f4906;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.loadGraphic(Paths.image('arctic/dialogue/max-suprise', 'shared'));
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
					}
			case 'sasha':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				titleText.text = "Sasha";
				titleText.color = 0xf982aa;
				titleText.borderColor = 0xFF90313b;
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.loadGraphic(Paths.image('arctic/dialogue/sasha', 'shared'));
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
					}
			case 'bf':
				titleText.text = "Boyfriend";
				titleText.color = 0x5ff6ff;
				titleText.borderColor = 0xFF398ed4;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bf-talk'), 0.6)];
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.loadGraphic(Paths.image('arctic/dialogue/bf', 'shared'));
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
					}
			case 'bfWHAT':
				titleText.text = "Boyfriend";
				titleText.color = 0x5ff6ff;
				titleText.borderColor = 0xFF398ed4;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bf-talk'), 0.6)];
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitLeft.loadGraphic(Paths.image('arctic/dialogue/bfWHAT', 'shared'));
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
					}
			case 'gf':
				titleText.text = "Girlfriend";
				titleText.color = 0xda3153;
				titleText.borderColor = 0xFF9f1e52;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gf-talk'), 0.6)];
				portraitRight.visible = false;
				portraitRight.visible = false;
				portraitLeft.loadGraphic(Paths.image('arctic/dialogue/gf', 'shared'));
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
					}
			//OTHER DIALOGUE MECHANICS

			//input control
			case 'stopInputs':
				canInput = false;
				addDialogue(false);
			case 'startInputs':
				canInput = true;
				addDialogue(false);

			//image below dialogue
			case 'hideBottomImage':
				bottomImage.visible = false;
				addDialogue(false);
			case 'showBottomImage':
				bottomImage.loadGraphic(Paths.image(dialogueList[0], 'shared'));
				bottomImage.visible = true;
				addDialogue(false);

			//image above dialogue
			case 'hideTopImage':
				topImage.visible = false;
				addDialogue(false);
			case 'showTopImage':
				topImage.loadGraphic(Paths.image(dialogueList[0], 'shared'));
				topImage.visible = true;
				addDialogue(false);
			
			//music control
			case 'playMusic':
				FlxG.sound.playMusic(Paths.music(dialogueList[0], 'shared'), .3);
				addDialogue(false);
			case 'pauseMusic':
				FlxG.sound.music.pause();
				addDialogue(false);
			case 'resumeMusic':
				FlxG.sound.music.resume();
				addDialogue(false);
				
			//sound control
			case 'playSound':
				funnySound = new FlxSound().loadEmbedded((Paths.sound(dialogueList[0], 'shared')));
				funnySound.play(true);
				//FlxG.sound.play(Paths.sound(dialogueList[0], 'shared'));
				addDialogue(false);
			case 'stopSound':
				funnySound.stop();
				addDialogue(false);

			//timing and stuff
			case 'timer':
				new FlxTimer().start(Std.parseFloat(dialogueList[0]), function(tmr:FlxTimer) 
				{
					addDialogue(false);
				});
			case 'buffer':
				//do nothing wait for an input
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}

	function endIt()
		if (!isEnding)
			{
				isEnding = true;
			
				FlxG.sound.music.fadeOut(1, 0);

	/* 							new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					box.alpha -= 1 / 5;
					bgFade.alpha -= 1 / 5 * 0.7;
					portraitLeft.visible = false;
					portraitRight.visible = false;
					portraitMiddle.visible = false;
					swagDialogue.alpha -= 1 / 5;
					dropText.alpha = swagDialogue.alpha;
					titleText.alpha = swagDialogue.alpha;
				}, 5); */

				FlxTween.tween(box, {y: 1000}, 1, {ease: FlxEase.quartIn});
				FlxTween.tween(titleText, {y: 1375}, 1, {ease: FlxEase.quartIn});
				FlxTween.tween(swagDialogue, {y: 1450}, 1, {ease: FlxEase.quartIn});
				FlxTween.tween(portraitLeft, {y: 1318}, 1, {ease: FlxEase.quartIn});
				FlxTween.tween(bgFade, {alpha: 0}, 1, {ease: FlxEase.quartIn});
				FlxTween.tween(bottomImage, {alpha: 0}, 1, {ease: FlxEase.quartIn});
				portraitRight.visible = false;
				portraitMiddle.visible = false;

				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					finishThing();
					kill();
				});
			}
}
