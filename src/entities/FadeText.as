package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	/**
	 * Text entity which fades in and out.
	 */
	public class FadeText extends Entity
	{
		private static const fadeTime:int = 40;
		private static const fade_in:int = 1;
		private static const fade_hold:int = 2;
		private static const fade_out:int = 3;
		
		private var src:String;
		private var image:Image;
		
		private var fading:int = 0;
		private var count:int = 0;
		private var holdTime:int;
		
		public function FadeText(text:String, holdTime:int, title:Boolean = false) 
		{
			super(80 - text.length * 2, 100);
			src = text;
			
			if (title)
			{
				Text.size = 32;
				text = "Cavern";
				graphic = image = new Text("Cavern");
				x = 24;
				y = 20;
				Text.size = 8;
			}
			else graphic = image = new Text(text);
			
			image.alpha = 0;
			this.holdTime = holdTime;
			fading = fade_in;
		}
		
		override public function update():void
		{
			if (fading == fade_in)
			{
				count++;
				image.alpha = count / fadeTime;
				if (count == fadeTime)
				{
					count = 0;
					fading = fade_hold;
				}
			}
			else if (fading == fade_hold && holdTime > 0)
			{
				count++;
				if (count == holdTime)
				{
					count = 0;
					fading = fade_out;
				}
			}
			else if (fading == fade_out)
			{
				count++;
				image.alpha = 1 - count / fadeTime;
				if (count == fadeTime)
				{
					(GameWorld)(FP.world).fadeText = null;
					FP.world.remove(this);
				}
			}
		}
		
		public function fadeOut():void
		{
			fading = fade_out;
		}
		
		public function getText():String
		{
			return src;
		}
		
	}

}