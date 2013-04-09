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
		public static var width:int = 1;
		public static var height:int = 1;
		public static var rooms:Array;
		
		[Embed(source = "../levels/mainworld.oel", mimeType = "application/octet-stream")]
		public static const mainworld:Class;
		
		public static function init():void
		{
			var x:int, y:int, i:int, j:int;
			// TODO: load an extra shell around the room arrays so the player can collide with those tiles.
			// TODO: separate tile graphic data and tile type data (graphics vs. soild/not solid) for simplicity ?
			
			var xml:XML = FP.getXML(mainworld);
			var node:XML;
			width = xml.@width / 160;
			height = xml.@height / 128;
			
			var whole:Array = new Array();
			for (i = 0; i < width * 10; i++) {
				whole[i] = new Array();
				for (j = 0; j < height * 10; j++)
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
					for (i = 0; i < 10; i++)
					{
						for (j = 0; j < 8; j++)
						{
							var p:Point = whole[x * 10 + i][y * 8 + j];
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