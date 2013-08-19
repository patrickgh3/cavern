package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Floating collectible orb that disappears when touched.
	 */
	public class Orb extends Entity
	{
		[Embed(source = "/../assets/orb.png")]
		private static const src:Class;
		
		private static const hovertime:int = 20;
		private static const movetime:int = 10;
		
		private var sprite:Spritemap;
		private var player:Player;
		
		private var count:int = 0;
		public var roomx:int;
		public var roomy:int;
		
		public function Orb(x:int, y:int, roomx:int, roomy:int) 
		{
			super(x, y);
			width = 6;
			height = 8;
			
			sprite = new Spritemap(src, 6, 8);
			sprite.setFrame(0);
			graphic = sprite;
			
			this.roomx = roomx;
			this.roomy = roomy;
			
			if (FP.world is GameWorld && (GameWorld)(FP.world).overlayMap.isOrbCollected(roomx, roomy))
			{
				(Image)(graphic).alpha = 0;
			}
		}
		
		override public function update():void
		{
			count++;
			if (count == hovertime)
			{
				sprite.setFrame(1);
			}
			else if (count == hovertime + movetime)
			{
				sprite.setFrame(2);
			}
			else if (count == hovertime + movetime + hovertime)
			{
				sprite.setFrame(1);
			}
			else if (count == hovertime + movetime + hovertime + movetime)
			{
				count = 0;
				sprite.setFrame(0);
			}
			
			if (player == null)
			{
				player = (GameWorld)(FP.world).player;
				if ((GameWorld)(FP.world).overlayMap.isOrbCollected(roomx, roomy)) FP.world.remove(this);
			}
			if (collidePlayer())
			{
				FP.world.remove(this);
				(GameWorld)(FP.world).overlayMap.collectOrb(roomx, roomy);
				for (var i:int = 0; i < 6; i++)
				{
					FP.world.add(new OrbParticle(x + 2, y + 2, Math.random() * Math.PI * 2));					
				}
				if ((GameWorld)(FP.world).donefadetextwarp == false)
				{
					(GameWorld)(FP.world).fadeText = new FadeText(GameWorld.text_warp, -1);
					FP.world.add((GameWorld)(FP.world).fadeText);
					(GameWorld)(FP.world).donefadetextwarp = true;
				}
			}
		}
		
		public function clone():Orb
		{
			return new Orb(x, y, roomx, roomy);
		}
		
		private function collidePlayer():Boolean
		{
			return x < player.x + player.width
				   && x + width > player.x
				   && y < player.y + player.height
				   && y + height > player.y;
		}
	}

}