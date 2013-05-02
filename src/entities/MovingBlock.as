package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Solid moving block that the player collides with.
	 */
	public class MovingBlock extends Entity
	{
		
		public function MovingBlock(x:int, y:int, xspeed:Number = 0, yspeed:Number = 0, width:int = 16, height:int = 16) 
		{
			super(x, y);
			this.width = width;
			this.height = height;
			graphic = Image.createRect(width, height, 0x77ff00);
		}
		
		public function clone():MovingBlock
		{
			return new MovingBlock(x, y); // TODO: add xspeed, width, path, etc
		}
		
	}

}