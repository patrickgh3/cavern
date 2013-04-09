package  
{
	import net.flashpunk.FP;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	
	/**
	 * Holds an array of rooms.
	 */
	public class RoomContainer 
	{
		public static var width:int;
		public static var height:int;
		public static var rooms:Array;
		
		[Embed(source = "../levels/mainworld.oel", mimeType = "application/octet-stream")]
		public static const mainworld:Class;
		
		public static function init():void
		{
			var x:int, y:int, i:int, j:int;
			
			var xml:XML = FP.getXML(mainworld);
			var node:XML;
			width = xml.@width / 160;
			height = xml.@height / 128;
			
			var whole:Array = new Array();
			for (i = 0; i < width * 10; i++) {
				whole[i] = new Array();
				for (j = 0; j < height * 8; j++)
				{
					whole[i][j] = new Point(1,0);
				}
			}
			
			for each (node in xml.Tiles.tile)
			{
				x = node.@x;
				y = node.@y;
				var tx:int = node.@tx;
				var ty:int = node.@ty;
				whole[x][y] = new Point(tx, ty);
			}
			
			rooms = new Array();
			for (x = 0; x < width; x++)
			{
				rooms[x] = new Array();
				for (y = 0; y < height; y++)
				{
					rooms[x][y] = new Room();
					// inner section (10 x 8)
					for (i = 1; i < 11; i++)
					{
						for (j = 1; j < 9; j++)
						{
							var p:Point = whole[x * 10 + (i - 1)][y * 8 + (j - 1)];
							rooms[x][y].tiles[i][j] = Tile.getTile((i - 1) * 16, (j - 1) * 16, p.x, p.y);
							rooms[x][y].level[i][j] = rooms[x][y].tiles[i][j].tileType;
						}
					}
					// outer shell
					for (i = 0; i < 12; i ++)
					{
						for (j = 0; j < 10; j++)
						{
							if ((i != 0 && i != 11) && (j != 0 && j != 9)) continue;
							var a:int = x * 10 + i - 1;
							var b:int = y * 8 + j - 1;
							if (a < 0 || a >= whole.length || b < 0 || b >= whole[0].length)
								p = new Point(1, 1);
							else
								p = whole[a][b];
							
							rooms[x][y].tiles[i][j] = Tile.getTile(i * 16, j * 16, p.x, p.y);
							rooms[x][y].level[i][j] = rooms[x][y].tiles[i][j].tileType;
						}
					}
				}
			}
		}
		
		public static function getRoom(x:int, y:int):Room
		{
			return rooms[x][y].clone();
		}
		
	}

}