package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Green rectangle which moves side to side as a background effect.
	 */
	public class GreenBlock extends Entity
	{
		[Embed(source = "/../assets/greenblock1.png")]
		private const greenblock1:Class;
		[Embed(source = "/../assets/greenblock2.png")]
		private const greenblock2:Class;
		
		public static const horizontal:int = 1;
		public static const vertical:int = 2;
		private static const speed_slow:Number = 2;
		private static const speed_fast:Number = 3;
		
		private var orientation:int;
		private var speed:Number;
		
		public function GreenBlock(type:int) 
		{
			super(Math.random() * 160, Math.random() * 128); // todo: better start randomization
			this.orientation = type;
			if (type == horizontal)
			{
				graphic = new Image(greenblock1);
			}
			else if (type == vertical)
			{
				graphic = new Image(greenblock2);
			}
			width = (Image)(graphic).width;
			height = (Image)(graphic).height;
			
			chooseSpeed();
		}
		
		override public function update():void
		{
			if (orientation == horizontal) x += speed;
			else if (orientation == vertical) y += speed;
			
			if (orientation == horizontal && (x > 160 || x < -width))
			{
				randomizeY();
				chooseSpeed();
				if (Math.random() < 0.5)
				{
					x = 160;
					speed *= -1;
				}
				else x = -width;
			}
			else if (orientation == vertical && (y > 128 || y < -height))
			{
				randomizeX();
				chooseSpeed();
				if (Math.random() < 0.5)
				{
					y = 128;
					speed *= -1;
				}
				else y = -height;
			}
		}
		
		private function chooseSpeed():void
		{
			if (Math.random() < 0.5) speed = speed_slow;
			else speed = speed_fast;
		}
		
		private function randomizeX():void
		{
			x = Math.random() * 144 - width / 2 + 8;
		}
		
		private function randomizeY():void
		{
			y = Math.random() * 112 - height / 2 + 8;
		}
		
	}

}