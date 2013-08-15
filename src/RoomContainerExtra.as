package  
{
	import extraentities.*;
	import net.flashpunk.FP;
	import flash.geom.Point;
	
	/**
	 * Holds two arrays of rooms for the game's introduction and ending.
	 * Most of this was copy-pasted from RoomContainer.
	 */
	public class RoomContainerExtra 
	{
		[Embed(source = "../levels/introworld.oel", mimeType = "application/octet-stream")]
		public static const introworld:Class;
		[Embed(source = "../levels/endworld.oel", mimeType = "application/octet-stream")]
		public static const endworld:Class;
		
		public static var width_intro:int;
		public static var width_end:int;
		public static var height_intro:int;
		public static var height_end:int;
		public static var rooms_intro:Array;
		public static var rooms_end:Array;
		
		public static function getIntroRoom(x:int, y:int):Room
		{
			return rooms_intro[x][y];
		}
		
		public static function getEndRoom(x:int, y:int):Room
		{
			return rooms_end[x][y];
		}
		
		public static function init():void
		{
			var x:int, y:int, i:int, j:int;
			
			var xml:XML = FP.getXML(introworld);
			var node:XML;
			width_intro = xml.@width / 160;
			height_intro = xml.@height / 128;
			
			var whole:Array = new Array();
			for (i = 0; i < width_intro * 10; i++) {
				whole[i] = new Array();
				for (j = 0; j < height_intro * 8; j++)
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
			
			rooms_intro = new Array();
			for (x = 0; x < width_intro; x++)
			{
				rooms_intro[x] = new Array();
				for (y = 0; y < height_intro; y++)
				{
					rooms_intro[x][y] = new Room();
					// inner section (10 x 8)
					for (i = 1; i < 11; i++)
					{
						for (j = 1; j < 9; j++)
						{
							var p:Point = whole[x * 10 + (i - 1)][y * 8 + (j - 1)];
							rooms_intro[x][y].tiles[i][j] = Tile.getTile((i - 1) * 16, (j - 1) * 16, p.x, p.y, rooms_intro[x][y]);
							rooms_intro[x][y].level[i][j] = rooms_intro[x][y].tiles[i][j].tileType;
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
							
							rooms_intro[x][y].tiles[i][j] = Tile.getTile(i * 16, j * 16, p.x, p.y, rooms_intro[x][y]);
							rooms_intro[x][y].level[i][j] = rooms_intro[x][y].tiles[i][j].tileType;
						}
					}
				}
			}
			
			var button:IntroButton;
			for each (node in xml.RoomData.IntroButton)
			{
				x = node.@x / 16;
				y = node.@y / 16;
				button = new IntroButton((x % 10) * 16, (y % 8) * 16);
				rooms_intro[int(x / 10)][int(y / 8)].actors.push(button);
			}
			
			for each (node in xml.RoomData.IntroPlayer)
			{
				x = node.@x / 16;
				y = node.@y / 16;
				rooms_intro[int(x / 10)][int(y / 8)].actors.push(new IntroPlayer((x % 10) * 16, (y % 8) * 16, button));
			}
			
			xml = FP.getXML(endworld);
			width_end = xml.@width / 160;
			height_end = xml.@height / 128;
			
			whole = new Array();
			for (i = 0; i < width_end * 10; i++) {
				whole[i] = new Array();
				for (j = 0; j < height_end * 8; j++)
				{
					whole[i][j] = new Point(1,0);
				}
			}
			
			for each (node in xml.Tiles.tile)
			{
				x = node.@x;
				y = node.@y;
				tx = node.@tx;
				ty = node.@ty;
				whole[x][y] = new Point(tx, ty);
			}
			
			rooms_end = new Array();
			for (x = 0; x < width_end; x++)
			{
				rooms_end[x] = new Array();
				for (y = 0; y < height_end; y++)
				{
					rooms_end[x][y] = new Room();
					// inner section (10 x 8)
					for (i = 1; i < 11; i++)
					{
						for (j = 1; j < 9; j++)
						{
							p = whole[x * 10 + (i - 1)][y * 8 + (j - 1)];
							rooms_end[x][y].tiles[i][j] = Tile.getTile((i - 1) * 16, (j - 1) * 16, p.x, p.y, rooms_end[x][y]);
							rooms_end[x][y].level[i][j] = rooms_end[x][y].tiles[i][j].tileType;
						}
					}
					// outer shell
					for (i = 0; i < 12; i++)
					{
						for (j = 0; j < 10; j++)
						{
							if ((i != 0 && i != 11) && (j != 0 && j != 9)) continue;
							a = x * 10 + i - 1;
							b = y * 8 + j - 1;
							if (a < 0 || a >= whole.length || b < 0 || b >= whole[0].length)
								p = new Point(1, 1);
							else
								p = whole[a][b];
							
							rooms_end[x][y].tiles[i][j] = Tile.getTile(i * 16, j * 16, p.x, p.y, rooms_end[x][y]);
							rooms_end[x][y].level[i][j] = rooms_end[x][y].tiles[i][j].tileType;
						}
					}
				}
			}
		}
		
	}

}