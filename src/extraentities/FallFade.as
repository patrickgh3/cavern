package extraentities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Black fade overlay used in the intro level.
	 */
	public class FallFade extends Entity
	{
		private var count:Number = 0;
		private var image:Image;
		private var state:int = 0;
		
		private static const fadeTime:Number = 240;
		
		public function FallFade() 
		{
			super(x, y);
			graphic = image = Image.createRect(160, 128, 0x000000);
			image.alpha = 0;
		}
		
		override public function update():void
		{
			if (state == 0)
			{
				count++;
				image.alpha = count / fadeTime;
			}
			else if (state == 1)
			{
				count++;
				image.alpha = 1 - count / 60;
				if (image.alpha <= 0) FP.world.remove(this);
			}
		}
		
		public function fadeIn():void
		{
			state = 1;
			image.alpha = 1;
			count = 0;
		}
		
	}

}