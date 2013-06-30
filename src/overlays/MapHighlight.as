package overlays 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Entity which flashes and moves to show the current room the player is in.
	 */
	public class MapHighlight extends Entity
	{
		[Embed(source = "/../assets/maphighlight.png")]
		private const src:Class;
		
		private var lastRoomX:int = -1;
		private var lastRoomY:int = -1;
		
		private var count:int = 0;
		private const flashtime:int = 10;
		
		public function MapHighlight() 
		{
			graphic = new Image(src);
		}
		
		public function setPosition(roomx:int, roomy:int, xoffset:int, yoffset:int):void
		{
			x = xoffset + roomx * (OverlayMap.cellwidth + OverlayMap.cellgap) - 1;
			y = yoffset + roomy * (OverlayMap.cellheight + OverlayMap.cellgap) - 1;
		}
		
		override public function update():void
		{
			
			count++;
			if (count == flashtime)
			{
				(Image)(graphic).alpha = 0;
			}
			else if (count == flashtime * 2)
			{
				count = 0;
				(Image)(graphic).alpha = 1;
			}
		}
		
	}

}