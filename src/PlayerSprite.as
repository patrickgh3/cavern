package  
{
	import entities.CrystalSpike;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import tiles.SpikeTile;
	
	/**
	 * Actual graphic of the player.
	 */
	public class PlayerSprite extends Entity
	{
		[Embed(source = "/../assets/player.png")]
		private static const src:Class;
		[Embed(source = "/../assets/sound/player_step.mp3")]
		private static const step:Class;
		[Embed(source = "/../assets/sound/player_jump.mp3")]
		private static const jump:Class;
		
		private static const walkRate:int = 4;
		private static const landTime:int = 6;
		private static const walkfromlandTime:int = 2;
		
		public const sfxStep:Sfx = new Sfx(step);
		public const sfxJump:Sfx = new Sfx(jump);
		public const sfxLand:Sfx = new Sfx(step);
		
		private var parent:Player;
		private var sprite:Spritemap;
		
		private var anim:String;
		private var count:int;
		private var lastYSpeed:int;
		private var lastOnGround:Boolean;
		private var walkfromlandcount:int;
		
		public function PlayerSprite(p:Player)
		{
			parent = p;
			parent.setSprite(this);
			
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			layer = -10;
		}
		
		override public function update():void
		{
			x = parent.x - (16 - parent.width) / 2;
			y = parent.y - (16 - parent.height);
			
			if (parent.getXSpeed() > 0) sprite.flipped = false;
			else if (parent.getXSpeed() < 0) sprite.flipped = true;
			
			if (parent.noclip)
			{
				sprite.setFrame(0, 0);
				return;
			}
			
			var onGround:Boolean = parent.onGround();
			var prev:String = anim;
			if (onGround && anim == "jump" && lastYSpeed > 1.5)
			{
				anim = "land"
				sfxLand.playCustom(0.5, this);
			}
			else if (onGround && parent.getXSpeed() != 0 && anim != "walk" && anim != "land")
			{
				if (anim != "endland") sfxStep.playCustom(0.15, this);
				if (anim == "endland") walkfromlandcount = 0;
				anim = "walk";
			}
			else if (onGround && parent.getXSpeed() == 0 && anim != "stand" && anim != "land")
			{
				anim = "stand";
			}
			else if (!onGround && parent.getYSpeed() != 0 && anim != "jump")
			{
				anim = "jump";
				if (parent.getYSpeed() < -1)
				{
					sfxJump.playCustom(0.4, this);
					CrystalSpike.triggerNext();
				}
			}
			if (anim != prev)
			{
				//trace("setting animation: " + anim);
				count = 0;
			}
			
			if (onGround && !lastOnGround && lastYSpeed <= 1.5) sfxStep.playCustom(0.25, this);
			
			switch (anim)
			{
				case "walk":
					if (count == walkRate * 4) count = 0;
					if (count == 0) sprite.setFrame(0, 1);
					else if (count == walkRate * 1) sprite.setFrame(1, 1);
					else if (count == walkRate * 2) sprite.setFrame(2, 1);
					else if (count == walkRate * 3) sprite.setFrame(3, 1);
					if (count == walkRate * 4 - 1) sfxStep.playCustom(0.15, this);
					if (walkfromlandcount == walkfromlandTime)
					{
						sfxStep.playCustom(0.15, this);
						walkfromlandcount++;
					}
					break;
					
				case "land":
					if (count < landTime) sprite.setFrame(2, 0);
					else if (count == landTime) anim = "endland";
					break;
					
				case "stand":
					if (count == 0) sprite.setFrame(0, 0);
					break;
					
				case "jump":
					if (count == 0) sprite.setFrame(1, 0);
					break;
			}
			
			count++;
			if (walkfromlandcount < walkfromlandTime) walkfromlandcount++;
			if (anim != "walk") walkfromlandcount = walkfromlandcount++;
			
			lastYSpeed = parent.getYSpeed();
			lastOnGround = onGround;
		}
		
		public function play(s:String):void
		{
			sprite.play(s);
		}
		
	}

}