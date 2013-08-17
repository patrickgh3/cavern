package tiles 
{
	import entities.CrumbleAnim;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	
	/**
	 * Tile that crumbles when the player touches it.
	 */
	public class CrumbleTile extends Tile
	{
		[Embed(source = "/../assets/crumble.png")]
		private static const src:Class;
		[Embed(source = "/../assets/sound/crumble.mp3")]
		private static const src2:Class;
		
		private static const crumbleTime:int = 30;
		
		private var sfxCrumble:Sfx;
		private var sprite:Spritemap;
		
		private var count:int = 0;
		private var crumbling:Boolean;
		
		public function CrumbleTile(xpos:int, ypos:int, r:Room) 
		{
			super(xpos, ypos, 0, 0, r, Tile.SOLID);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			sfxCrumble = new Sfx(src2);
		}
		
		override public function update():void
		{
			if (crumbling)
			{
				count++;
				if (count == crumbleTime) setLevel(Tile.EMPTY);
			}
		}
		
		override public function touch():void
		{
			if (!crumbling)
			{
				crumbling = true;
				FP.world.add(new CrumbleAnim(x, y));
				sprite.setFrame(0, 1);
				sfxCrumble.playCustom(1, this);
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new CrumbleTile(x, y, r);
		}
		
	}

}