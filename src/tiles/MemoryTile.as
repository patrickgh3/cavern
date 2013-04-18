package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Tile which flickers between solid and empty based on its timing.
	 */
	public class MemoryTile extends Tile
	{
		private static const numstates:int = 16;
		private static const switchspeed:int = 15;
		public static var count:int = 0;
		public static var innercount:int = 0;
		
		private var source:String;
		private var states:Array; // 0 is empty, 1 is solid
		private var sprite:Spritemap;
		
		[Embed(source = "/../assets/memory.png")]
		private const src:Class;
		
		public function MemoryTile(xpos:int, ypos:int, r:Room, source:String) 
		{
			super(xpos, ypos, 0, 0, r, 1);
			this.source = source;
			states = new Array(numstates);
			for (var i:int = 0; i < numstates; i++)
			{
				states[i] = source.charAt(i);
			}
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			_room.level[(x / 16) + 1][(y / 16) + 1] = tileType;
			sprite.setFrame(states[count], 0);
		}
		
		override public function update():void
		{
			if (states[count] != states[count == 0 ? numstates - 1 : count - 1])
			{
				tileType = states[count];
				_room.level[(x / 16) + 1][(y / 16) + 1] = tileType;
				sprite.setFrame(states[count], 0);
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new MemoryTile(x, y, r, source);
		}
		
		public static function update():void
		{
			innercount++;
			if (innercount == switchspeed)
			{
				innercount = 0;
				count++;
				if (count == numstates) count = 0;
			}
		}
		
	}

}