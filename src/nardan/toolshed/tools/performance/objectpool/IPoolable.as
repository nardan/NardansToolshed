package nardan.toolshed.tools.performance.objectpool 
{
	
	/**
	 * May be useful when pooling objects.
	 * These functions get called by ObjectPool
	 * 
	 * getPrepare(): Gets called when being retrieved from it's pool 
	 * setPrepare(): Gets called when returned to it's pool
	 * 
	 * @author real_nardan@hotmail.com
	 * @see nardan.toolshed.tools.performance.ObjectPool
	 */
	public interface IPoolable 
	{
		function getPrepare():void;
		function setPrepare():void;
	}
	
}