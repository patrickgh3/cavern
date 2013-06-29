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
		
		private var gw:GameWorld;
		
		private var lastRoomX:int;
		private var lastRoomY:int;
		
		private var count:int = 0;
		private const flashtime:int = 10;
		
		public function MapHighlight(x:int, y:int) 
		{
			super(x, y);
			graphic = new Image(src);
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
			
			if (gw == null)
			{
				gw = (GameWorld)(FP.world);
				lastRoomX = gw.roomX;
				lastRoomY = gw.roomY;
			}
			if (lastRoomX != gw.roomX || lastRoomY != gw.roomY)
			{
				x += (gw.roomX - lastRoomX) * (OverlayMap.cellwidth + OverlayMap.cellgap);
				y += (gw.roomY - lastRoomY) * (OverlayMap.cellheight + OverlayMap.cellgap);
				lastRoomX = gw.roomX;
				lastRoomY = gw.roomY;
			}
		}
		
	}

}