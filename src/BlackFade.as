package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Black overlay that fades out and in upon reloading a room.
	 */
	public class BlackFade extends Entity
	{
		private var count:int;
		private const fadeTime:int = 20; // frames taken to fade out / in
		private const waitTime:int = 30; // frames held while alpha = 1;
		private var image:Image;
		
		public function BlackFade() 
		{
			graphic = Image.createRect(160, 128, 0x000000);
			Image(graphic).alpha = 0;
		}
		
		override public function update():void
		{
			count++;
			if (count <= fadeTime)
			{
				Image(graphic).alpha = count / fadeTime;
			}
			else if (count == fadeTime + waitTime)
			{
				GameWorld(FP.world).addPlayer();
			}
			else if ((count > fadeTime + waitTime) && (count < waitTime + 2 * fadeTime))
			{
				Image(graphic).alpha = 1 - (count - waitTime - fadeTime) / fadeTime;
			}
			else if (count == waitTime + 2 * fadeTime)
			{
				Image(graphic).alpha = 0;
			}
				
		}
		
	}

}