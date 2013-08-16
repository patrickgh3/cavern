package tiles 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * Tile that switches on and off upon player touch.
	 * http://www.youtube.com/watch?v=LBaUkQNxAUY
	 */
	public class SwitchTile extends Tile
	{
		[Embed(source = "/../assets/switch.png")]
		private const src:Class;
		[Embed(source = "/../assets/sound/switch_on.mp3")]
		private const on:Class;
		[Embed(source = "/../assets/sound/switch_off.mp3")]
		private const off:Class;
		
		public static var numTiles:int = 0; // these values are set in Room's clone function. kinda messy.
		public static var numActivated:int = 0;
		
		private var activated:Boolean;
		private var touchedLast:Boolean = false;
		private var sprite:Spritemap;
		private var player:Player;
		private var sfxOn:Sfx;
		private var sfxOff:Sfx;
		
		public function SwitchTile(xpos:int, ypos:int, r:Room, switchstatus:Boolean)
		{
			super(xpos, ypos, 0, 0, r, Tile.SOLID);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			activated = switchstatus;
			
			sfxOn = new Sfx(on);
			sfxOff = new Sfx(off);
			
			if (activated) sprite.setFrame(1, 0);
			else sprite.setFrame(0, 0);
		}
		
		override public function update():void
		{
			if (player == null) player = GameWorld(FP.world).player;
			// if touched last and player is not near us
			if (touchedLast && !(
				x - 1 < player.x + player.width
				&& x + 17 > player.x
				&& y - 1 < player.y + player.height
				&& y + 17 > player.y))
			{
			   touchedLast = false;
			}
		}
		
		override public function touch():void
		{
			if (!touchedLast)
			{
				activated = !activated;
				if (activated)
				{
					sprite.setFrame(1, 0);
					numActivated++;
					sfxOn.playCustom(1, this);
				}
				else
				{
					sprite.setFrame(0, 0);
					numActivated--;
					sfxOff.playCustom(1, this);
				}
				touchedLast = true;
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new SwitchTile(x, y, r, activated);
		}
		
		public function isActivated():Boolean
		{
			return activated;
		}
		
	}

}