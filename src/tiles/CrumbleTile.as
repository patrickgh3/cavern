package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Tile that crumbles when the player touches it.
	 */
	public class CrumbleTile extends Tile
	{
		[Embed(source = "/../assets/crumble.png")]
		private const src:Class;
		
		private const crumbleTime:int = 30;
		
		private var sprite:Spritemap;
		private var count:int = 0;
		private var crumbling:Boolean;
		
		public function CrumbleTile(xpos:int, ypos:int, r:Room) 
		{
			super(xpos, ypos, 0, 0, r, Tile.SOLID);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
		}
		
		override public function update():void
		{
			if (crumbling)
			{
				count++;
				Image(graphic).alpha = 1 - count / crumbleTime;
				if (count == crumbleTime)
				{
					_room.level[(x / 16) + 1][(y / 16) + 1] = 0;
					Image(graphic).alpha = 0;
				}
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new CrumbleTile(x, y, r);
		}
		
		override public function touch():void
		{
			if (!crumbling)
			{
				crumbling = true;
			}
		}
		
	}

}