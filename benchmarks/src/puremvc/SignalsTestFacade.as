package puremvc
{
	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * @author Omar Gonzalez
	 */
	public class SignalsTestFacade extends Facade
	{
		static public function getInstance():SignalsTestFacade
		{
			if (!instance)
				instance = new SignalsTestFacade();
			
			return instance as SignalsTestFacade;
		}
	}
}
