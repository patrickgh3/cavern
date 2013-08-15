package extraentities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import tiles.IntroBridgeTile;
	
	/**
	 * Player NPC in the intro level.
	 */
	public class IntroPlayer extends Entity
	{
		[Embed(source = "/../assets/player.png")]
		private const src:Class;
		[Embed(source = "/../assets/sound/player_step.mp3")]
		private const step:Class;
		[Embed(source = "/../assets/sound/player_jump.mp3")]
		private const jump:Class;
		
		private var gw:GameWorld;
		private var realPlayer:Entity;
		private var button:IntroButton;
		private var sprite:Spritemap;
		
		private var activated:Boolean = false;
		private var finished:Boolean = false;
		private var count:int = 0;
		private var xspeed:Number = 0;
		private var yspeed:Number = 0;
		private var endy:int;
		
		private const runSpeed:Number = 1.5;
		private const grav:Number = 0.13;
		private const jumpSpeed:Number = 2.89;
		
		private const startwaittime:int = 120;
		private const movetime:int = 22;
		
		public function IntroPlayer(x:int, y:int, b:IntroButton) 
		{
			super(x, y);
			
			endy = this.y - 8;
			button = b;
			sprite = new Spritemap(src, 16, 16);
			sprite.flipped = true;
			graphic = sprite;
		}
		
		override public function update():void
		{
			if (gw == null) gw = (GameWorld)(FP.world);
			if (realPlayer == null) realPlayer = (GameWorld)(FP.world).player;
			
			if (activated)
			{
				// jump
				if (count == startwaittime)
				{
					new Sfx(jump).play();
					yspeed = -jumpSpeed;
					sprite.setFrame(1, 0);
				}
				// start moving left
				else if (count == startwaittime + 10)
				{
					xspeed = -runSpeed;
				}
				// stop moving left
				else if (count == startwaittime + 32)
				{
					xspeed = 0;
				}
				
				x += xspeed;
				y += yspeed;
				if (count >= startwaittime) yspeed += grav;
				
				// landing
				if (y > endy && count > startwaittime + 2)
				{
					y = endy + 4;
					activated = false;
					finished = true;
					new Sfx(step).play(0.4);
					sprite.setFrame(0, 0);
					button.press();
					IntroBridgeTile.drop();
				}
				
				count++;
			}
			
			if (realPlayer.x > 66 && !activated && !finished)
			{
				activated = true;
				gw.room.level[2][4] = Tile.SOLID;
				gw.room.level[2][5] = Tile.SOLID;
				gw.room.level[2][6] = Tile.SOLID;
				gw.player.stopXMovement(true);
			}
			
		}
		
	}

}