package tiles 
{
	/**
	 * Tile which is randomly solid or empty each time the room is loaded.
	 */
	public class ProbabilityTile extends Tile
	{
		private var solid_prob:Number;
		
		public function ProbabilityTile(xpos:int, ypos:int, x:int, y:int, r:Room, solid_prob:Number) 
		{
			super(xpos, ypos, x, y, r, Tile.EMPTY);
			this.solid_prob = solid_prob;
		}
		
		override public function clone(r:Room):Tile
		{
			if (Math.random() < solid_prob)
			{
				var t:Tile = new Tile(x, y, _x, _y, r, Tile.SOLID);
				t.setLevel(Tile.SOLID);
				return t;
			}
			else return new Tile(x, y, 2, 2, r, Tile.EMPTY);
		}
		
	}

}