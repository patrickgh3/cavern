package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * Tile which changes between solid and empty based on its timing.
	 */
	public class MemoryTile extends Tile
	{
		[Embed(source = "/../assets/memory.png")]
		private const src:Class;
		[Embed(source = "/../assets/sound/memorytile.mp3")]
		private static const click:Class;
		
		private static const numstates:int = 16;
		private static const switchspeed:int = 17;
		public static var count:int = 0;
		public static var innercount:int = 0;
		
		private var animcount:int = animspeed * 4 + 1;
		private static const animspeed:int = 4;
		
		private var source:String;
		private var states:Array; // 0 is empty, 1 is solid
		private var sprite:Spritemap;
		
		private static var sfxClick:Sfx = new Sfx(click);
		
		public function MemoryTile(xpos:int, ypos:int, r:Room, source:String, playsound:Boolean = false) 
		{
			super(xpos, ypos, 0, 0, r, 1);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			this.source = source;
			
			states = new Array(numstates);
			for (var i:int = 0; i < numstates; i++)
				states[i] = source.charAt((i + 12) % 16);
			sprite.setFrame(states[count], 0);
			tileType = states[count];
			setLevel(tileType);
			if (states[count] == Tile.SOLID)
			{
				animcount = 0;
				if (playsound) sfxClick.play();
			}
		}
		
		override public function update():void
		{
			// if states[count] is not the same as states[previous count] then switch states.
			if (innercount == 0 && states[count] != states[count == 0 ? numstates - 1 : count - 1])
			{
				tileType = states[count];
				setLevel(tileType);
				sprite.setFrame(states[count], 0);
				if (states[count] == Tile.SOLID)
				{
					animcount = 0;
					sfxClick.play();
				}
			}
			if (animcount <= animspeed * 4)
			{
				if (animcount == animspeed * 4)
				{
					sprite.setFrame(1, 0);
				}
				else if (animcount % animspeed == 0)
				{
					sprite.setFrame(animcount / animspeed, 1);
				}
				animcount++;
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new MemoryTile(x, y, r, source, true);
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