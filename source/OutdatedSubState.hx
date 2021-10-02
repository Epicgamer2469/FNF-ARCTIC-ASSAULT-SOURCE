package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.addons.text.FlxTypeText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var funnyShit:Bool = false;
	var txt:FlxText;

	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";
	//var funnyName:String;
	var funnyTxt:FlxTypeText;
	var talk:FlxSprite;

	var trole:FlxSprite;
	
	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;

	override function create()
	{
		super.create();

		//funnyName = Sys.environment()["USERNAME"];

		talk = new FlxSprite(0, 0).loadGraphic(Paths.image('talk1', 'shared'));
		talk.screenCenter(X);
		talk.scale.set(.7, .7);
		talk.antialiasing = true;
		add(talk);

		trole = new FlxSprite().loadGraphic(Paths.image('trole', 'shared'));
		trole.alpha = 0;
		trole.screenCenter();
		trole.scale.set(2.6, 2.4);
		trole.antialiasing = true;
		
		var kadeLogo:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('KadeEngineLogo'));
		kadeLogo.scale.y = 0.3;
		kadeLogo.scale.x = 0.3;
		kadeLogo.x -= kadeLogo.frameHeight;
		kadeLogo.y -= 180;
		kadeLogo.alpha = 0.8;
		//add(kadeLogo);
		
		txt = new FlxText(0, 0, FlxG.width,
			"Hello there, just here to say thanks for downloading the mod!"
			+ "\n\nCurrently this is just a demo and some things could change."
			+ "\nSo please be patient while we work on the full week, \nWe dont want anything bad happening now do we?\n\nAnyways, have fun!"
			+ "\n\nPress [ANY KEY] to continue.",
			32);
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		txt.y += 60;
		add(txt);

		add(trole);

/* 		funnyTxt = new FlxTypeText(0, 0, FlxG.width, "..." + funnyName, 32);
		funnyTxt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		funnyTxt.borderColor = FlxColor.BLACK;
		funnyTxt.borderSize = 3;
		funnyTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		funnyTxt.screenCenter();
		funnyTxt.sounds = [FlxG.sound.load(Paths.sound('boom'), 0.6)];
		funnyTxt.visible = false;
		funnyTxt.y += 60;
		add(funnyTxt); */
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if(kadeLogo.angle == -10) FlxTween.angle(kadeLogo, kadeLogo.angle, 10, 2, {ease: FlxEase.quartInOut});
			else FlxTween.angle(kadeLogo, kadeLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		}, 0);
		
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			if(kadeLogo.alpha == 0.8) FlxTween.tween(kadeLogo, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
			else FlxTween.tween(kadeLogo, {alpha: 0.8}, 0.8, {ease: FlxEase.quartInOut});
		}, 0);
	}

	override function update(elapsed:Float)
	{
		if(FlxG.keys.justPressed.ANY && !funnyShit)
			{
				leftState = true;
				trole.alpha = 1;
				FlxG.sound.play(Paths.sound('boom'));
				FlxTween.tween(trole, {alpha: 0}, 1);
				FlxG.sound.music.volume = 1;

				new FlxTimer().start(1.1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new MainMenuState());
					});
			}
/* 		else if (FlxG.keys.justPressed.ANY)
			{
				txt.visible = false;
				FlxG.sound.music.fadeOut(.25);
				talk.loadGraphic(Paths.image('talk2', 'shared'));
				funnyTxt.visible = true;
				funnyTxt.start(0.15, true);
				funnyShit = true;
			} */
		super.update(elapsed);
	}
}
