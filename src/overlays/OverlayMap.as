package overlays 
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Overlay activated with the X key that shows the world map.
	 */
	public class OverlayMap extends Entity
	{
		private var background:Entity;
		private var cells:Array;
		private var i:int, j:int;
		
		public static const cellwidth:int = 7;
		public static const cellheight:int = 5;
		public static const cellgap:int = 2;
		
		private var xoffset:int;
		private var yoffset:int;
		
		public function OverlayMap() 
		{
			background = new Entity(0, 0);
			background.graphic = Image.createRect(160, 128, 0x000000);
			(Image)(background.graphic).alpha = 0.4;
			
			xoffset = (160 - (RoomContainer.width * (cellwidth + cellgap) - cellgap)) / 2;
			yoffset = (128 - (RoomContainer.height * (cellheight + cellgap) - cellgap)) / 2;
			cells = new Array(width);
			for (i = 0; i < RoomContainer.width; i++)
			{
				cells[i] = new Array(height);
				for (j = 0; j < RoomContainer.height; j++)
				{
					cells[i][j] = new MapCell(xoffset + i * (cellwidth + cellgap), yoffset + j * (cellheight + cellgap));
				}
			}
		}
		
		override public function update():void
		{
			
		}
		
		public function addSelf():void
		{
			var w:World = FP.world;
			w.add(background);
			for (i = 0; i < cells.length; i++)
			{
				for (j = 0; j < cells[0].length; j++)
				{
					w.add(cells[i][j]);
				}
			}
		}
		
		
		public function removeSelf():void
		{
			var w:World = FP.world;
			w.remove(background);
			for (i = 0; i < cells.length; i++)
			{
				for (j = 0; j < cells[0].length; j++)
				{
					w.remove(cells[i][j]);
				}
			}
		}
		
	}

}