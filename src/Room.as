package  
{
	import net.flashpunk.Entity;
	
	/**
	 * Holds the data for a room in the game (10 by 12 tiles, including outer edges).
	 */
	public class Room 
	{
		private static const width:int = 12;
		private static const height:int = 10;
		
		public var level:Array;
		public var tiles:Array;
		public var entities:Array;
		
		public function Room() 
		{
			level = new Array(width);
			tiles = new Array(width);
			for (var i:int = 0; i < width; i++)
			{
				level[i] = new Array();
				tiles[i] = new Array();
				for (var j:int = 0; j < height; j++)
				{
					level[i][j] = 0;
				}
			}
		}
		
		public function clone():Room
		{
			var r:Room = new Room();
			for (var i:int = 0; i < width; i++)
			{
				for (var j:int = 0; j < height; j++)
				{
					r.level[i][j] = level[i][j];
					if (tiles[i][j] != null) r.tiles[i][j] = tiles[i][j].clone();
				}
			}
			return r;
		}
		
		public static function printRoom(r:Room):void
		{
			for (var y:int = 0; y < height; y++)
			{
				var s:String = "";
				for (var x:int = 0; x < width; x++)
				{
					//s += r.level[x][y] + " ";
					if (r.level[x][y] == 1) s += "Q ";
					else s += "- ";
					s += " ";
				}
				trace(s);
			}
			trace("\n\n");
		}
		
	}

}