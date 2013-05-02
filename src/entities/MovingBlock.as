package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Solid moving block that the player collides with.
	 */
	public class MovingBlock extends Entity
	{
		public var xspeed:Number;
		public var yspeed:Number;
		private var player:Player;
		
		private var count:int = 0;
		private const tempSwitchTime:int = 70;
		
		public function MovingBlock(x:int, y:int, xspeed:Number = 0, yspeed:Number = 0, width:int = 16, height:int = 16) 
		{
			super(x, y);
			this.width = width;
			this.height = height;
			this.xspeed = xspeed;
			this.yspeed = yspeed;
			graphic = Image.createRect(width, height, 0x77ff00);
			
			// temp
			if (Math.random() > 0.5)
				this.xspeed = 0.3;
			else
				this.yspeed = 0.3;
		}
		
		override public function update():void
		{
			if (player == null) player = GameWorld(FP.world)._player;
			
			count++;
			if (count == tempSwitchTime)
			{
				count = 0;
				xspeed *= -1;
				yspeed *= -1;
			}
			
			x += xspeed;
			y += yspeed;
			
			
			
			while (collidePlayer() && !(xspeed == 0 && yspeed == 0) && !player.noclip)
			{
				player.x += 0.2 * Util.sign(xspeed);
				player.y += 0.2 * Util.sign(yspeed);
			}
		}
		
		private function collidePlayer():Boolean
		{
			return x < player.x + player.width - 0.5
				   && x + width > player.x
				   && y + 1 < player.y + player.height
				   && y + height > player.y;
		}
		
		public function clone():MovingBlock
		{
			return new MovingBlock(x, y); // TODO: add xspeed, width, path, etc
		}
		
	}

}