package  
{
	/**
	 * Generic utility class.
	 */
	public class Util 
	{
		public static function sign(n:Number):int
		{
			if (n == 0) return 0;
			else return Math.abs(n) / n;
		}
	}

}