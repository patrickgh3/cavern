package overlays 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Cell in the array of the map overlay.
	 */
	public class MapCell extends Entity
	{
		public static const color_white:Number = 0xffffff;
		
		public static const orb_present:int = 0;
		public static const orb_obtained:int = 0;
		public static const orb_none:int = 0;
		
		public function MapCell(x:int, y:int, color:Number = color_white, discovered:Boolean = false, orbstatus:int = 0) 
		{
			super(x, y);
			graphic = Image.createRect(OverlayMap.cellwidth, OverlayMap.cellheight, color);
			//if (!discovered) setAlpha(0);
		}
		
		public function makeVisible():void
		{
			setAlpha(1);
		}
		
		public function removeOrb():void
		{
			trace("removing orb: not implemented yet");
		}
		
		private function setAlpha(a:Number):void
		{
			(Image)(graphic).alpha = a;
		}
	}

}