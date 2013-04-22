package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Animated tile of lightning-electricity.
	 */
	public class LightningTile extends Tile
	{
		[Embed(source = "/../assets/lightning.png")]
		private static const src:Class;
		
		public static const HORIZONTAL:int = 0;
		public static const VERTICAL:int = 1;
		
		private const animSpeed:int = 5;
		
		private var count:int = 0;
		private var orientation:int;;
		private var sprite:Spritemap;
		
		public function LightningTile(xpos:int, ypos:int, r:Room, orientation:int) 
		{
			super(xpos, ypos, 0, 0, r, Tile.INSTAKILL);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			this.orientation = orientation;
		}
		
		override public function update():void
		{
			count++;
			if (count == animSpeed * 3) count = 0;
			if (count % animSpeed == 0)
			{
				sprite.setFrame(count / animSpeed, orientation);
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new LightningTile(x, y, r, orientation);
		}
		
	}

}