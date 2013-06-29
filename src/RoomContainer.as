package  
{
	import net.flashpunk.FP;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import tiles.FactoryTile;
	import tiles.MemoryTile;
	import entities.MovingBlock;
	
	/**
	 * Holds an array of rooms, initialized on startup.
	 */
	public class RoomContainer 
	{
		[Embed(source = "../levels/mainworld.oel", mimeType = "application/octet-stream")]
		public static const mainworld:Class;
		
		public static var width:int;
		public static var height:int;
		public static var rooms:Array;
		public static var sounds:Array;
		public static var mapcolors:Array;
		public static var mapcolorvalues:Object;
		
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
			
			mapcolorvalues = new Object();
			mapcolorvalues.white = 0xffffff;
			mapcolorvalues.darkred = 0x801D1D;
			
			sounds = new Array();
			mapcolors = new Array();
			for (i = 0; i < width; i++)
			{
				sounds[i] = new Array();
				mapcolors[i] = new Array();
				for (j = 0; j < height; j++)
				{
					mapcolors[i][j] = 0xffffff;
					sounds[i][j] = "silence";
				}
			}
			for each (node in xml.RoomData.RoomProperties)
			{
				x = node.@x / 160;
				y = node.@y / 128;
				sounds[x][y] = node.@sound;
				mapcolors[x][y] = mapcolorvalues[node.@mapcolor];
			}
			
			for each (node in xml.Tiles.tile)
			{
				x = node.@x;
				y = node.@y;
				var tx:int = node.@tx;4
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
							rooms[x][y].tiles[i][j] = Tile.getTile((i - 1) * 16, (j - 1) * 16, p.x, p.y, rooms[x][y]);
							rooms[x][y].level[i][j] = rooms[x][y].tiles[i][j].tileType;
						}
					}
					// outer shell
					for (i = 0; i < 12; i++)
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
							
							rooms[x][y].tiles[i][j] = Tile.getTile(i * 16, j * 16, p.x, p.y, rooms[x][y]);
							rooms[x][y].level[i][j] = rooms[x][y].tiles[i][j].tileType;
						}
					}
				}
			}
			
			for (x = 0; x < width; x++)
			{
				for (y = 0; y < height; y++)
				{
					for (i = 1; i < 11; i++)
					{
						for (j = 1; j < 9; j++)
						{
							if (rooms[x][y].tiles[i][j] is FactoryTile) (rooms[x][y].tiles[i][j] as FactoryTile).createGraphic();
						}
					}
				}
			}
			for (x = 0; x < width; x++)
			{
				for (y = 0; y < height; y++)
				{
					for (i = 0; i < 12; i++)
					{
						for (j = 0; j < 10; j++)
						{
							if ((x == 0 && i == 0) || (x == width - 1 && i == 11) || (y == 0 && j == 0) || (y == height - 1 && j == 9))
								continue;
							if (rooms[x][y].level[i][j] == Tile.FACTORY_TEMP)
							{
								rooms[x][y].tiles[i][j].tileType = Tile.SOLID;
								rooms[x][y].level[i][j] = Tile.SOLID;
							}
						}
					}
				}
			}
			
			for each (node in xml.RoomData.MemoryTile)
			{
				// devil magic
				x = node.@x / 16;
				y = node.@y / 16;
				rooms[int(x / 10)][int(y / 8)].tiles[x % 10 + 1][y % 8 + 1] =
					new MemoryTile((x % 10) * 16, (y % 8) * 16, rooms[int(x / 10)][int(y / 8)], node.@states);
				rooms[int(x / 10)][int(y / 8)].level[x % 10 + 1][y % 8 + 1] =
					rooms[int(x / 10)][int(y / 8)].tiles[x % 10 + 1][y % 8 + 1].tileType;
			}
			
			for each (node in xml.RoomData.MovingBlock)
			{
				// devil magic
				x = node.@x / 16;
				y = node.@y / 16;
				rooms[int(x / 10)][int(y / 8)].actors.push(
					new MovingBlock((x % 10) * 16, (y % 8) * 16, node.@speed, node.@path));
			}
		}
		
		public static function cloneRoom(x:int, y:int):Room
		{
			return rooms[x][y].clone();
		}
		
	}

}