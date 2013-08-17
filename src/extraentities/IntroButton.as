package extraentities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Button pressed in the intro level.
	 */
	public class IntroButton extends Entity
	{
		[Embed(source = "/../assets/introbutton.png")]
		private static const src:Class;
		
		private var sprite:Spritemap;
		
		public function IntroButton(x:int, y:int) 
		{
			super(x, y);
			
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
		}
		
		public function press():void
		{
			sprite.setFrame(1, 0);
			// TODO: sound effect?
		}
		
	}

}