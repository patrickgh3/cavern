package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Particle used during the player's respawn animation.
	 */
	public class PlayerParticle extends Entity
	{
		
		public function PlayerParticle() 
		{
			super(0, 0);
			graphic = Image.createRect(3, 3, 0xffffff);
		}
		
		override public function update():void
		{
			
		}
		
	}

}