package flexUnitTests
{
	import org.signalscircuit.puremvc.as3.patterns.command.MacroSignalCommand;
	
	public class TestMacroSignalCommand extends MacroSignalCommand
	{
		override protected function initializeMacroCommand():void
		{
			super.initializeMacroCommand();
			
			addSubCommand(TestSimpleSignalCommand);
		}
	}
}