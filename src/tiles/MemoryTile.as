package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Tile which oscillates between solid and empty based on its timing.
	 */
	public class MemoryTile extends Tile
	{
		[Embed(source = "/../assets/memory.png")]
		private const src:Class;
		
		private static const numstates:int = 16;
		private static const switchspeed:int = 15;
		public static var count:int = 0;
		public static var innercount:int = 0;
		
		private var source:String;
		private var states:Array; // 0 is empty, 1 is solid
		private var sprite:Spritemap;
		
		public function MemoryTile(xpos:int, ypos:int, r:Room, source:String) 
		{
			super(xpos, ypos, 0, 0, r, 1);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			this.source = source;
			
			states = new Array(numstates);
			for (var i:int = 0; i < numstates; i++)
				states[i] = source.charAt(i);
			sprite.setFrame(states[count], 0);
		}
		
		override public function update():void
		{
			// if states[count] is not the same as states[previous count] then switch states.
			if (states[count] != states[count == 0 ? numstates - 1 : count - 1])
			{
				tileType = states[count];
				setLevel(tileType);
				sprite.setFrame(states[count], 0);
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new MemoryTile(x, y, r, source);
		}
		
		// called once per update in GameWorld before updating entities.
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