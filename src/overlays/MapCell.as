package overlays 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Cell in the array of the map overlay.
	 */
	public class MapCell extends Entity
	{
		private static const color_orbgone:int = 0x333333;
		
		private var color:Number;
		private var buffer:BitmapData;
		
		public function MapCell(x:int, y:int, color:Number, hasorb:Boolean = false, discovered:Boolean = false) 
		{
			super(x, y);
			this.color = color;
			
			buffer = new BitmapData(OverlayMap.cellwidth, OverlayMap.cellheight, true, color);
			graphic = new Image(buffer);
			if (!discovered) (Image)(graphic).alpha = 0;
			
			if (hasorb)
			{
				//buffer.setPixel(2, 1, 0xffffff);
				buffer.setPixel(3, 1, 0xffffff);
				//buffer.setPixel(4, 1, 0xffffff);
				buffer.setPixel(2, 2, 0xffffff);
				buffer.setPixel(3, 2, 0xffffff);
				buffer.setPixel(4, 2, 0xffffff);
				//buffer.setPixel(2, 3, 0xffffff);
				buffer.setPixel(3, 3, 0xffffff);
				//buffer.setPixel(4, 3, 0xffffff);
			}
		}
		
		public function makeVisible():void
		{
			(Image)(graphic).alpha = 1;
		}
		
		public function removeOrb():void
		{
			//buffer.setPixel(2, 1, color_orbgone);
			buffer.setPixel(3, 1, color_orbgone);
			//buffer.setPixel(4, 1, color_orbgone);
			buffer.setPixel(2, 2, color_orbgone);
			buffer.setPixel(3, 2, color_orbgone);
			buffer.setPixel(4, 2, color_orbgone);
			//buffer.setPixel(2, 3, color_orbgone);
			buffer.setPixel(3, 3, color_orbgone);
			//buffer.setPixel(4, 3, color_orbgone);
			graphic = new Image(buffer);
		}
	}

}