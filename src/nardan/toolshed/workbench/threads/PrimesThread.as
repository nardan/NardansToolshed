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
		private var primeIndex:uint;
		/* **************************************** *
		 * Constructor
		 * **************************************** */
		public function PrimesThread() 
		{
			primes =  new Vector.<uint>();
			primes.push(2);
			checkNum = 3;
			primeIndex = 0;
			super(20, 200);
		}
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		/* **************************************** *
		 * Public Methods
		 * **************************************** */
		override public function iterate():Boolean 
		{
			//trace('PrimesThread::iterate');
			super.iterate();
			trace('PrimesThread::iterate checkNum = ' + checkNum + ' primes[primeIndex] = ' + primes[primeIndex]);
			var found:Boolean = Boolean(checkNum % primes[primeIndex] == 0);
			
			//should we stop?
			if (checkNum == uint.MAX_VALUE && primeIndex == primes.length -1) {
				if (found) primes.push(checkNum);
				terminate();
				return false;
			}
			
			if (found) {
				
				//primes.push(checkNum);
				++checkNum;
				primeIndex = 0;
				
			}else {
				primeIndex = (primeIndex + 1) % primes.length;
				if (primeIndex == 0 ) {
					//trace('PrimesThread::iterate PRIME! = ' + checkNum + ' primes.length = ' + primes.length);
					primes.push(checkNum);
					++checkNum;
				}
			}
			
			return true;
		}
		
		override public function terminate():void 
		{
			trace('PrimesThread::terminate');
			super.terminate();
		}
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		
	}

	
}