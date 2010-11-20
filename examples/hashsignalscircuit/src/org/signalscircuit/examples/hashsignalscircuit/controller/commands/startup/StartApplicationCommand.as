package org.signalscircuit.examples.hashsignalscircuit.controller.commands.startup
{
	import org.osflash.signals.Signal;
	import org.signalscircuit.examples.hashsignalscircuit.model.proxies.TwitterProxy;
	import org.signalscircuit.examples.hashsignalscircuit.view.HashSignalsCircuitView;
	import org.signalscircuit.examples.hashsignalscircuit.view.HashSignalsCircuitMediator;
	import org.signalscircuit.puremvc.as3.patterns.command.SimpleSignalCommand;

	/**
	 * @author Omar Gonzalez
	 */
	public class StartApplicationCommand extends SimpleSignalCommand
	{
		/**
		 * @inheritDoc
		 */
		override public function execute(signal:Signal, args:Array):void
		{
			// Get Signal argument
			var hashSignalsCircuit:HashSignalsCircuitView = args[0];
			
			// Start view mediators
			facade.registerMediator(new HashSignalsCircuitMediator(hashSignalsCircuit));
			
			// Start data proxies
			var twitterProxy:TwitterProxy = new TwitterProxy();
			facade.registerProxy(twitterProxy);
			
			// Load tweets for #SignalsCircuit
			twitterProxy.loadHashTag("SignalsCircuit");
		}
	}
}
