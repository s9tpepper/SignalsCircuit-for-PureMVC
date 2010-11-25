package org.signalscircuit.examples.hashsignalscircuit.controller.commands.twitter
{
	import org.signalscircuit.examples.hashsignalscircuit.view.HashSignalsCircuitMediator;
	import ab.fl.utils.json.JSON;
	import org.osflash.signals.Signal;
	import org.signalscircuit.puremvc.as3.patterns.command.SimpleSignalCommand;

	/**
	 * @author Omar Gonzalez
	 */
	public class HashTagLoadedCommand extends SimpleSignalCommand
	{
		/**
		 * @inheritDoc
		 */
		override public function execute(signal:Signal, args:Array):void
		{
			var json:JSON = args[0];
			var results:Array = json.results.valueOf();

			//var hashSignalsCircuitMediator:HashSignalsCircuitMediator = facade.retrieveMediator(HashSignalsCircuitMediator.NAME) as HashSignalsCircuitMediator;
			
			//var hashSignalsCircuitMediator:HashSignalsCircuitMediator = getMediator(HashSignalsCircuitMediator.NAME);
			
			var hsm:HashSignalsCircuitMediator = gm(HashSignalsCircuitMediator.NAME);
			
			
			hsm.setDisplay(results);
		}
	}
}
