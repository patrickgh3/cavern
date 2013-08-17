package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Orb which appears on the shrine.
	 */
	public class ShrineOrb extends Entity
	{
		[Embed(source = "/../assets/shrineorb.png")]
		private static const src:Class;
		
		public function ShrineOrb(x:int, y:int) 
		{
			super(x, y);
			graphic = new Image(src);
			(Image)(graphic).color = 0x202020;
		}
		
		public function makeWhite():void
		{
			(Image)(graphic).color = 0xffffff;
		}
		
	}

}