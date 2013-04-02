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
		public static const width:int = 1;
		public static const height:int = 1;
		public static var rooms:Array;
		
		[Embed(source = "../levels/mainworld.oel", mimeType = "application/octet-stream")]
		public static const mainworld:Class;
		
		public static function init():void
		{
			// load a large array 
			var x:int, y:int, i:int, j:int;
			var whole:Array = new Array();
			for (i = 0; i < width; i++)
				whole[i] = new Array();
			
			var xml:XML = FP.getXML(mainworld);
			var node:XML;
			for each (node in xml.Tiles.tile)
			{
				x = node.@x;
				y = node.@y;
				whole[x][y] = new Point(node.@tx, node.@ty);
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
							rooms[x][y].level[i][j] = whole[x * 10 + i][y * 8 + j];
						}
					}
				}
			}
		}
		
		public static function getRoom(x:int, y:int):Room
		{
			return new Room();
		}
		
	}

}