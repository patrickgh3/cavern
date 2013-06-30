package  
{
	import entities.MovingBlock;
	import entities.Orb;
	import net.flashpunk.Entity;
	import tiles.SwitchTile;
	import tiles.MemoryTile;
	import entities.MovingBlock;
	import net.flashpunk.FP;
	
	/**
	 * Holds the data for a room in the game (10 by 12 tiles, including outer edges).
	 */
	public class Room 
	{
		private static const width:int = 12;
		private static const height:int = 10;
		
		public var level:Array;
		public var tiles:Array;
		public var actors:Array;
		
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
			actors = new Array();
		}
		
		public function clone():Room
		{
			SwitchTile.numTiles = 0;
			SwitchTile.numActivated = 0;
			MemoryTile.count = 0;
			MemoryTile.innercount = 0;
			
			var r:Room = new Room();
			
			for (var i:int = 0; i < width; i++)
			{
				for (var j:int = 0; j < height; j++)
				{
					r.level[i][j] = level[i][j];
					if (tiles[i][j] != null) r.tiles[i][j] = Tile(tiles[i][j]).clone(r);
					r.tiles[i][j].roomStart();
					
					if (r.tiles[i][j] is SwitchTile)
					{
						SwitchTile.numTiles++;
						if (SwitchTile(r.tiles[i][j]).isActivated()) SwitchTile.numActivated++;
					}
				}
			}
			
			for (i = 0; i < actors.length; i++)
			{
				if (actors[i] is MovingBlock)
					r.actors.push(MovingBlock(actors[i]).clone());
				else if (actors[i] is Orb)
					r.actors.push(Orb(actors[i]).clone());
			}
			
			return r;
		}
		
		public static function traceRoom(r:Room):void
		{
			for (var y:int = 0; y < height; y++)
			{
				var s:String = "";
				for (var x:int = 0; x < width; x++)
				{
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