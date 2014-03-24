package  
{
	import net.flashpunk.Sfx;
	
	/**
	 * Handles the looping tracks determined by the room.
	 */
	public class Ambiance 
	{
		[Embed(source = "/../assets/sound/amb_silence.mp3")] private static const silence:Class;
		[Embed(source = "/../assets/sound/amb_cave.mp3")] private static const cave:Class;
		[Embed(source = "/../assets/sound/amb_cave2.mp3")] private static const cave2:Class;
		[Embed(source = "/../assets/sound/amb_cave3.mp3")] private static const cave3:Class;
		[Embed(source = "/../assets/sound/amb_greenblock.mp3")] private static const greenblock:Class;
		[Embed(source = "/../assets/sound/amb_wind.mp3")] private static const wind:Class;
		[Embed(source = "/../assets/sound/amb_factory.mp3")] private static const factory:Class;
		[Embed(source = "/../assets/sound/amb_factory2.mp3")] private static const factory2:Class;
		[Embed(source = "/../assets/sound/amb_crystal.mp3")] private static const crystal:Class;
		
		private static const sfxSilence:Sfx = new Sfx(silence);
		private static const sfxCave:Sfx = new Sfx(cave);
		private static const sfxCave2:Sfx = new Sfx(cave2);
		private static const sfxCave3:Sfx = new Sfx(cave3);
		private static const sfxGreenBlock:Sfx = new Sfx(greenblock);
		private static const sfxWind:Sfx = new Sfx(wind);
		private static const sfxFactory:Sfx = new Sfx(factory);
		private static const sfxFactory2:Sfx = new Sfx(factory2);
		private static const sfxCrystal:Sfx = new Sfx(crystal);
		
		private static var fading:Boolean;
		private static var count:int;
		private static const fadeTime:int = 120;
		
		private static var current:Sfx;
		private static var fadeOut:Sfx;
		
		public static function update():void
		{
			if (fading)
			{
				current.volume += 1 / fadeTime;
				fadeOut.volume -= 1 / fadeTime;
				
				count++;
				if (count == fadeTime)
				{
					fading = false;
					fadeOut.stop();
					current.volume = 1;
				}
			}
		}
		
		public static function switchTo(s:String):void
		{
			var n:Sfx = sfxSilence;
			if (s == "silence") n = sfxSilence;
			else if (s == "cave") n = sfxCave;
			else if (s == "cave2") n = sfxCave2;
			else if (s == "cave3") n = sfxCave3;
			else if (s == "greenblock") n = sfxGreenBlock;
			else if (s == "wind") n = sfxWind;
			else if (s == "factory") n = sfxFactory;
			else if (s == "factory2") n = sfxFactory2;
			else if (s == "crystal") n = sfxCrystal;
			//else trace("invalid ambiance: " + s + ". Setting to silence.");
			
			if (n == current) return;
			
			if (!fading)
			{
				fadeOut = current;
				current = n;
				current.loop();
				current.volume = 0;
				fading = true;
				count = 0;
			}
			else if (fading)
			{
				fadeOut.stop();
				fadeOut = current;
				fadeOut.volume = 1;
				current = n;
				current.loop();
				current.volume = 0;
				count = 0;
			}
		}
		
		public static function init():void
		{
			current = sfxSilence;
			fadeOut = sfxSilence;
		}
	}

}