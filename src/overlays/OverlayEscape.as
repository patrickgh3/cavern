package overlays 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	
	/**
	 * Overlay activated with Esc key that shows game info and controls.
	 */
	public class OverlayEscape
	{
		private var background:Entity;
		
		public function OverlayEscape() 
		{
			background = new Entity(0, 0);
			background.graphic = Image.createRect(160, 128, 0x000000);
			(Image)(background.graphic).alpha = 0.4;
		}
		
		public function addSelf():void
		{
			var w:World = FP.world;
			w.add(background);
		}
		
		public function removeSelf():void
		{
			var w:World = FP.world;
			w.remove(background);
		}
	}

}