package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Entity which kills the player upon contact.
	 */
	public class Instakiller extends Entity
	{
		private var player:Player;
		
		public function Instakiller(x:int, y:int, w:int, h:int) 
		{
			super(x, y);
			width = w;
			height = h;
		}
		
		override public function update():void
		{
			if (player == null) player = GameWorld(FP.world)._player;
			if (collidePlayer() && !player.noclip && !player.dead)
				GameWorld(FP.world).killPlayer();
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