package overlays 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Cell in the array of the map overlay.
	 */
	public class MapCell extends Entity
	{
		public static const orb_present:int = 0;
		public static const orb_obtained:int = 0;
		public static const orb_none:int = 0;
		
		private var color:Number;
		
		public function MapCell(x:int, y:int, color:Number = 0xffffff, orbstatus:int = 0, discovered:Boolean = false) 
		{
			super(x, y);
			graphic = Image.createRect(OverlayMap.cellwidth, OverlayMap.cellheight, color);
			if (!discovered) (Image)(graphic).alpha = 0;
			this.color = color;
		}
		
		public function makeVisible():void
		{
			(Image)(graphic).alpha = 1;
		}
		
		public function removeOrb():void
		{
			trace("removing orb: not implemented yet");
		}
		
		public function getColor():Number
		{
			return color;
		}
	}

}