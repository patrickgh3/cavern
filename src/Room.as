package  
{
	import net.flashpunk.Entity;
	
	/**
	 * Holds the data for a room in the game (8 by 10 tiles).
	 */
	public class Room 
	{
		
		public var level:Array;
		public var tiles:Array;
		public var entities:Array;
		
		public function Room() 
		{
			level = new Array(10);
			tiles = new Array(10);
			for (var i:int = 0; i < 10; i++)
			{
				level[i] = new Array();
				tiles[i] = new Array();
				for (var j:int = 0; j < 8; j++)
				{
					level[i][j] = 0;
				}
			}
		}
		
		public function clone():Room
		{
			var r:Room = new Room();
			for (var i:int = 0; i < 10; i++)
			{
				for (var j:int = 0; j < 8; j++)
				{
					r.level[i][j] = level[i][j];
					r.tiles[i][j] = tiles[i][j].clone();
				}
			}
			return r;
		}
		
		public static function printRoom(r:Room):void
		{
			for (var y:int = 0; y < 8; y++)
			{
				var s:String = "";
				for (var x:int = 0; x < 10; x++)
				{
					s += r.level[x][y] + " ";
					s += " ";
				}
				trace(s);
			}
		}
		
	}

}