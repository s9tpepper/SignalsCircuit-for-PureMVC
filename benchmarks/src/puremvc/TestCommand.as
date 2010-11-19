package puremvc
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author Omar Gonzalez
	 */
	public class TestCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
		}
	}
}
