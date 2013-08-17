package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Animation that playes for CrumbleTile.
	 */
	public class CrumbleAnim extends Entity
	{
		[Embed(source = "/../assets/crumble.png")]
		private static const src:Class;
		
		private static const numframes:int = 4;
		private static const animrate:int = 10;
		
		private var count:int = 0;
		private var sprite:Spritemap;
		
		public function CrumbleAnim(x:int, y:int) 
		{
			super(x, y);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
		}
		
		override public function update():void
		{
			count++;
			if (count % animrate == 0)
			{
				if (count < animrate * numframes)
				{
					sprite.setFrame(count / animrate);
				}
				else
				{
					FP.world.remove(this);
				}
			}
		}
		
	}

}