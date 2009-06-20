package nardan.toolshed.workbench.threads 
{
	import nardan.toolshed.parts.performance.thread.Thread;
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public class PrimesThread extends Thread
	{
		/* **************************************** *
		* Static Constants + Variables
		* **************************************** */
		/***************************************** *
		 * Static Methods
		 * **************************************** */
		/* **************************************** *
		 * Properties
		* **************************************** */
		public var primes:Vector.<uint>;
		private var checkNum:uint;
		private var nextPrimeIndex:uint;
		/* **************************************** *
		 * Constructor
		 * **************************************** */
		public function PrimesThread() 
		{
			primes =  new Vector.<uint>();
			primes.push(2);
			checkNum = 3;
			nextPrimeIndex = 0;
			super(20, 200);
		}
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		/* **************************************** *
		 * Public Methods
		 * **************************************** */
		override public function runSlice():Boolean 
		{
			//trace('PrimesThread::runSlice');
			super.runSlice();
			//trace('PrimesThread::runSlice checkNum = ' + checkNum + ' primes[nextPrimeIndex] = ' + primes[nextPrimeIndex]);
			var found:Boolean = Boolean(checkNum % primes[nextPrimeIndex] == 0);
			
			//should we stop?
			if (checkNum == uint.MAX_VALUE && nextPrimeIndex == primes.length -1) {
				if (found) primes.push(checkNum);
				kill();
				return false;
			}
			
			if (found) {
				
				primes.push(checkNum);
				++checkNum;
				nextPrimeIndex = 0;
				
			}else {
				nextPrimeIndex = (nextPrimeIndex + 1) % primes.length;
				if (nextPrimeIndex == 0 ) {
					trace('PrimesThread::runSlice PRIME! = ' + checkNum + ' primes.length = ' + primes.length);
					++checkNum;
				}
			}
			
			return true;
		}
		
		override public function kill():void 
		{
			trace('PrimesThread::kill');
			super.kill();
		}
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		
	}

	
}