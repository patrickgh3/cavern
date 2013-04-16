package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import tiles.*;
	
	/**
	 * A basic tile in the game's grid.
	 */
	public class Tile extends Entity
	{
		public static const EMPTY:int = 0;
		public static const SOLID:int = 1;
		public static const INSTAKILL:int = 2;
		
		public var tileType:int;
		protected var _x:int;
		protected var _y:int
		protected var _room:Room;
		
		[Embed(source = "/../levels/tileset1.png")]
		private const TILES:Class;
		
		public function Tile(xpos:int, ypos:int, x:int, y:int, r:Room, type:int) 
		{
			super(xpos, ypos);
			_x = x;
			_y = y;
			_room = r;
			tileType = type;
			graphic = new Image(TILES, new Rectangle(x * 16, y * 16, 16, 16));
		}
		
		public function roomStart():void { }
		
		public static function getTile(xpos:int, ypos:int, x:int, y:int, r:Room):Tile
		{
			if (x == 0 && y == 0) return new LavaTile(xpos, ypos, r, LavaTile.CENTER);
			else if (x == 1 && y == 0) return new LavaTile(xpos, ypos, r, LavaTile.TOP);
			else if (x == 2 && y == 0) return new CrumbleTile(xpos, ypos, r);
			else if (x == 3 && y == 0) return new LavaDropTile(xpos, ypos, r);
			else if (x == 5 && y == 0) return new SwitchDoorTile(xpos, ypos, r);
			else if (x == 6 && y == 0) return new SwitchTile(xpos, ypos, r, false);
			else if (x == 7 && y == 0) return new SwitchTile(xpos, ypos, r, true);		
			
			var t:int = 0;
			if (y == 0) t = 2;
			else if (y == 1) t = 1;
			else if (y == 2) t = 0;
			return new Tile(xpos, ypos, x, y, r, t);
		}
		
		public function clone(r:Room):Tile
		{
			return new Tile(x, y, _x, _y, r, tileType);
		}
		
		public function touch():void { }
		
	}

}