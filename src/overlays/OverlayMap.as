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
		 * Element divisible by 5 = orb has been collected.
		 */
		private var i:int, j:int;
		
		public static const cellwidth:int = 7;
		public static const cellheight:int = 5;
		public static const cellgap:int = 2;
		
		private var xoffset:int;
		private var yoffset:int;
		private var isVisible:Boolean = false;
		private var highlight:MapHighlight;
		
		public function OverlayMap(spawnX:int, spawnY:int) 
		{
			background = new Entity(0, 0);
			background.graphic = Image.createRect(160, 128, 0x000000);
			(Image)(background.graphic).alpha = 0.6;
			
			xoffset = (160 - (RoomContainer.width * (cellwidth + cellgap) - cellgap)) / 2;
			yoffset = (128 - (RoomContainer.height * (cellheight + cellgap) - cellgap)) / 2;
			
			highlight = new MapHighlight(xoffset + spawnX * (cellwidth + cellgap) - 1,
										 yoffset + spawnY * (cellheight + cellgap) - 1);
			
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
											  RoomContainer.mapcolors[i][j],
											  RoomContainer.hasorb[i][j]);
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
		
		public function collectOrb(roomx:int, roomy:int):void
		{
			data[roomx][roomy] *= 5;
			cells[roomx][roomy].removeOrb();
		}
		
		private function addLink(roomx:int, roomy:int, horizontal:Boolean):void
		{
			var link:Entity = new Entity(xoffset + roomx * (cellwidth + cellgap), yoffset + roomy * (cellheight + cellgap));
			if (horizontal)
			{
				link.x += cellwidth;
				link.y += cellheight / 2;
				link.graphic = Image.createRect(cellgap, 1, RoomContainer.mapcolors[roomx][roomy]);
			}
			else
			{
				link.x += cellwidth / 2;
				link.y += cellheight;
				link.graphic = Image.createRect(1, cellgap, RoomContainer.mapcolors[roomx][roomy]);
			}
			links.push(link);
			if (isVisible) FP.world.add(link);
		}
		
		public function addSelf():void
		{
			isVisible = true;
			var w:World = FP.world;
			w.add(background);
			w.add(highlight);
			for (i = 0; i < links.length; i++) w.add(links[i]);
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
			isVisible = false;
			var w:World = FP.world;
			w.remove(background);
			w.remove(highlight);
			for (i = 0; i < links.length; i++) w.remove(links[i]);
			for (i = 0; i < cells.length; i++)
			{
				for (j = 0; j < cells[0].length; j++)
				{
					w.remove(cells[i][j]);
				}
			}
		}
		
		public function isOrbCollected(roomx:int, roomy:int):Boolean
		{
			return data[roomx][roomy] % 5 == 0 && data[roomx][roomy] != 0;
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