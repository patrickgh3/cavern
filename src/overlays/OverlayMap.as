package overlays 
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Overlay activated with the X key that shows the world map.
	 */
	public class OverlayMap
	{
		private var background:Entity;
		private var links:Array; // List of all visible "link" objects.
		private var cells:Array; // 2D array of MapCell objects.
		private var data:Array;  // 2D array of ints storing data about discoveries and links (for local storage).
		/* Element is zero = undiscovered (else discovered)
		 * Element divisible by 2 = link to the right.
		 * Element divisible by 3 = link to the bottom.
		 */
		private var i:int, j:int;
		
		public static const cellwidth:int = 7;
		public static const cellheight:int = 5;
		public static const cellgap:int = 2;
		
		private static var colorvalues:Object;
		
		private var xoffset:int;
		private var yoffset:int;
		private var isVisible:Boolean = false;
		
		public function OverlayMap() 
		{
			background = new Entity(0, 0);
			background.graphic = Image.createRect(160, 128, 0x000000);
			(Image)(background.graphic).alpha = 0.4;
			
			colorvalues = new Object();
			colorvalues.white = 0xffffff;
			colorvalues.darkred = 0x801D1D;
			
			xoffset = (160 - (RoomContainer.width * (cellwidth + cellgap) - cellgap)) / 2;
			yoffset = (128 - (RoomContainer.height * (cellheight + cellgap) - cellgap)) / 2;
			
			links = new Array();
			cells = new Array();
			data = new Array();
			for (i = 0; i < RoomContainer.width; i++)
			{
				cells[i] = new Array();
				data[i] = new Array();
				for (j = 0; j < RoomContainer.height; j++)
				{
					data[i][j] = 0;
					cells[i][j] = new MapCell(xoffset + i * (cellwidth + cellgap),
											  yoffset + j * (cellheight + cellgap),
											  colorvalues[RoomContainer.getMapColor(i, j)]);
				}
			}
		}
		
		public function linkRight(roomx:int, roomy:int):void
		{
			discover(roomx, roomy);
			if (data[roomx][roomy] % 2 != 0)
			{
				data[roomx][roomy] *= 2;
				addLink(roomx, roomy, true);
			}
		}
		
		public function linkLeft(roomx:int, roomy:int):void
		{
			discover(roomx, roomy);
			if (data[roomx - 1][roomy] % 2 != 0)
			{
				data[roomx - 1][roomy] *= 2;
				addLink(roomx - 1, roomy, true);
			}
		}
		
		public function linkBottom(roomx:int, roomy:int):void
		{
			discover(roomx, roomy);
			if (data[roomx][roomy] % 3 != 0)
			{
				data[roomx][roomy] *= 3;
				addLink(roomx, roomy, false);
			}
		}
		
		public function linkTop(roomx:int, roomy:int):void
		{
			discover(roomx, roomy);
			if (data[roomx][roomy - 1] % 3 != 0)
			{
				data[roomx][roomy - 1] *= 3;
				addLink(roomx, roomy - 1, false);
			}
		}
		
		public function discover(roomx:int, roomy:int):void
		{
			if (data[roomx][roomy] == 0)
			{
				data[roomx][roomy] = 1;
				cells[roomx][roomy].makeVisible();
			}
		}
		
		private function addLink(roomx:int, roomy:int, horizontal:Boolean):void
		{
			var link:Entity = new Entity(xoffset + roomx * (cellwidth + cellgap), yoffset + roomy * (cellheight + cellgap));
			if (horizontal)
			{
				link.x += cellwidth;
				link.y += cellheight / 2;
				link.graphic = Image.createRect(cellgap, 1, cells[roomx][roomy].getColor());
			}
			else
			{
				link.x += cellwidth / 2;
				link.y += cellheight;
				link.graphic = Image.createRect(1, cellgap, cells[roomx][roomy].getColor());
			}
			links.push(link);
			if (isVisible) FP.world.add(link);
		}
		
		public function addSelf():void
		{
			isVisible = true;
			var w:World = FP.world;
			w.add(background);
			for (i = 0; i < cells.length; i++)
			{
				for (j = 0; j < cells[0].length; j++)
				{
					w.add(cells[i][j]);
				}
			}
			for (i = 0; i < links.length; i++) w.add(links[i]);
		}
		
		public function removeSelf():void
		{
			isVisible = false;
			var w:World = FP.world;
			w.remove(background);
			for (i = 0; i < cells.length; i++)
			{
				for (j = 0; j < cells[0].length; j++)
				{
					w.remove(cells[i][j]);
				}
			}
			for (i = 0; i < links.length; i++) w.remove(links[i]);
		}
		
		public function traceData():void
		{
			for (j = 0; j < RoomContainer.height; j++)
			{
				var s:String = "";
				for (i = 0; i < RoomContainer.width; i++)
				{
					s += data[i][j];
					s += " ";
				}
				trace(s);
			}
			trace();
		}
		
	}

}