package org.signalscircuit.puremvc.as3.patterns.command
{
	import org.osflash.signals.Signal;
	import org.puremvc.as3.interfaces.INotifier;
	import org.puremvc.as3.patterns.observer.Notifier;
	import org.signalscircuit.puremvc.as3.interfaces.ISignalCommand;

	/**
	 * @author Omar Gonzalez
	 */
	public class SimpleSignalCommand extends Notifier implements ISignalCommand, INotifier
	{
		/**
		 * @inheritDoc
		 */
		public function execute(signal:Signal, args:Array):void
		{
		}
	}
}
