package flexUnitTests
{
	import org.osflash.signals.Signal;
	import org.signalscircuit.puremvc.as3.patterns.command.SimpleSignalCommand;
	
	public class TestSimpleSignalCommand extends SimpleSignalCommand
	{
		/**
		 * @inherit
		 */
		override public function execute(signal:Signal, args:Array):void
		{
			SignalsCircuitTests.TEST_SIGNAL_EXECUTION.dispatch();
		}
		
	}
}