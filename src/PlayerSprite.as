package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Actual graphic of the player.
	 */
	public class PlayerSprite extends Entity
	{
		[Embed(source = "/../assets/player.png")]
		private const src:Class;
		
		private const walkRate:int = 5;
		private const landTime:int = 6;
		
		private var parent:Player;
		private var sprite:Spritemap = new Spritemap(src, 16, 16);
		private var anim:String;
		private var count:int;
		private var lastYSpeed:int;
		
		public function PlayerSprite(p:Player) 
		{
			parent = p;
			parent.setSprite(this);
			
			graphic = sprite;
		}
		
		override public function update():void
		{
			x = parent.x - (16 - parent.width) / 2;
			y = parent.y - (16 - parent.height);
			
			if (parent.getXSpeed() > 0) sprite.flipped = false;
			else if (parent.getXSpeed() < 0) sprite.flipped = true;
			
			var onGround:Boolean = parent.onGround();
			var prev:String = anim;
			if (onGround && anim == "jump" && lastYSpeed > 1.5)
			{
				anim = "land"
			}
			else if (onGround && parent.getXSpeed() != 0 && anim != "walk" && anim != "land")
			{
				anim = "walk";
			}
			else if (onGround && parent.getXSpeed() == 0 && anim != "stand" && anim != "land")
			{
				anim = "stand";
			}
			else if (!onGround && parent.getYSpeed() != 0 && anim != "jump")
			{
				anim = "jump";
			}
			if (anim != prev)
			{
				//trace("setting animation: " + anim);
				count = 0;
			}
			
			switch (anim)
			{
				case "walk":
					if (count == walkRate * 4) count = 0;
					if (count == 0) sprite.setFrame(0, 1);
					else if (count == walkRate * 1) sprite.setFrame(1, 1);
					else if (count == walkRate * 2) sprite.setFrame(2, 1);
					else if (count == walkRate * 3) sprite.setFrame(3, 1);
					break;
					
				case "land":
					if (count < landTime) sprite.setFrame(2, 0);
					else if (count == landTime) anim = "a"
					break;
					
				case "stand":
					if (count == 0) sprite.setFrame(0, 0);
					break;
					
				case "jump":
					if (count == 0) sprite.setFrame(1, 0);
					break;
			}
			count++;
			
			lastYSpeed = parent.getYSpeed();
		}
		
		public function play(s:String):void
		{
			sprite.play(s);
		}
		
	}

}