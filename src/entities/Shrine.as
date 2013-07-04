package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	
	/**
	 * Shrine which holds orbs after they are collected.
	 */
	public class Shrine extends Entity
	{
		[Embed(source = "/../assets/shrine.png")]
		private const src:Class;
		
		private static const xoffset:int = 17;
		private static const yoffset:int = 12;
		
		private var orbs:Array;
		
		public function Shrine(x:int, y:int) 
		{
			super(x, y);
			graphic = new Image(src);
			
			orbs = new Array();
			for (var i:int = 0; i < 16; i++)
			{
				orbs[i] = new ShrineOrb(x + xoffset + i * 8 - (int(i / 8) * 64), y + yoffset + (int(i / 8) * 8));
			}
		}
		
		public function activateOrb(i:int):void
		{
			(ShrineOrb)(orbs[i]).makeWhite();
		}
		
		public function addOrbs(w:World):void
		{
			for (var i:int = 0; i < 16; i++)
			{
				w.add(orbs[i]);
			}
		}
	}

}