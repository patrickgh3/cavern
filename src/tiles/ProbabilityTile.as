package tiles 
{
	/**
	 * Tile which is randomly solid or empty each time the room is loaded.
	 */
	public class ProbabilityTile extends Tile
	{
		private var solid_prob:Number;
		private var _x2:int;
		private var _y2:int;
		
		public function ProbabilityTile(xpos:int, ypos:int, x:int, y:int, x2:int, y2:int, r:Room, solid_prob:Number) 
		{
			super(xpos, ypos, x, y, r, Tile.EMPTY);
			this.solid_prob = solid_prob;
			this._x2 = x2;
			this._y2 = y2;
		}
		
		override public function clone(r:Room):Tile
		{
			if (Math.random() < solid_prob)
			{
				var t:Tile = new Tile(x, y, _x, _y, r, Tile.SOLID);
				t.setLevel(Tile.SOLID);
				return t;
			}
			else return new Tile(x, y, _x2, _y2, r, Tile.EMPTY);
		}
		
	}

}