package tiles 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Tile which constructs its own graphic based on factorytile.png.
	 */
	public class FactoryTile extends Tile
	{
		[Embed(source = "/../assets/factory.png")]
		private static const src:Class;
		
		private static var sprite:Spritemap;
		private static var source:BitmapData = FP.getBitmap(src);
		
		public function FactoryTile(xpos:int, ypos:int, r:Room, presetgraphic:Graphic = null) 
		{
			super(xpos, ypos, 0, 0, r, Tile.FACTORY_TEMP);
			if (presetgraphic != null)
				graphic = presetgraphic;
		}
		
		override public function clone(r:Room):Tile
		{
			return new FactoryTile(x, y, r, graphic);
		}
		
		public function createGraphic():void
		{
			var data:BitmapData = new BitmapData(16, 16);
			var tx:int = int(x / 16) + 1;
			var ty:int = int(y / 16) + 1;
			
			for (var i:int = 0; i < 2; i++)
			{
				for (var j:int = 0; j < 2; j++)
				{
					var ii:int = i * 2 - 1;
					var jj:int = j * 2 - 1;
					var v:Boolean = getFactory(tx, ty + jj);
					var h:Boolean = getFactory(tx + ii, ty);
					var c:Boolean = getFactory(tx + ii, ty + jj);
					var xx:int = 0;
					var yy:int = 0;
					// edge on up/down side
					if (!v && h)
					{
						xx = 1;
						yy = 3 * j;
					}
					// edge on left/right side
					else if (!h && v)
					{
						xx = 3 * i;
						yy = 1;
					}
					// outside corner
					else if (!c && !v && !h)
					{
						xx = 3 * i;
						yy = 3 * j;
					}
					// inside corner
					else if (!c && v && h)
					{
						xx = 1 + i;
						yy = 1 + j;
					}
					// solid
					else if (v && h && c)
					{
						xx = 4 + i;
						yy = 0 + j;
					}
					data.copyPixels(source, new Rectangle(xx * 8, yy * 8, 8, 8), new Point(i * 8, j * 8));
				}
			}
			graphic = new Image(data);
		}
		
		private function getFactory(x:int, y:int):Boolean
		{
			if (x == 0 || x == 11 || y == 0 || y == 9)
				return _room.level[x][y] == Tile.FACTORY_TEMP || _room.level[x][y] == Tile.SOLID;
			else
				return _room.level[x][y] == Tile.FACTORY_TEMP;
		}
		
	}

}