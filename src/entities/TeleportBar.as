package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	/**
	 * White loading bar shown when the player wants to teleport to the shrine.
	 */
	public class TeleportBar extends Entity
	{
		private var player:Player;
		private var image:Image;
		
		private var count:int = 0;
		public static const teleportTime:int = 60;
		private static const maxwidth:int = 24;
		private static const normalheight:int = 4;
		
		public function TeleportBar(p:Player) 
		{
			super(p.x, p.y);
			player = p;
			graphic = image = Image.createRect(maxwidth, normalheight, 0xffffff);
			image.scaleX = 1 / maxwidth;
		}
		
		override public function update():void
		{
			x = (int)(player.x + player.width / 2 - maxwidth / 2);
			y = (int)(player.y - 2 - normalheight);
			
			if (!Input.check(Key.C) || player.dead)
			{
				count = 0;
			}
			else
			{
				count++;
			}
			updateImage();
			
			if (count == teleportTime)
			{
				count = 0;
				updateImage();
				(GameWorld)(FP.world).teleportBarFull();
			}
		}
		
		public function resetCount():void
		{
			count = 0;
			updateImage();
		}
		
		private function updateImage():void
		{
			image.scaleX = (int)((count / teleportTime) * maxwidth) / maxwidth;
			if (count == 0) image.alpha = 0;
			else image.alpha = 1;
		}
		
	}

}