package org.puremvc.as3.patterns.command
{
	import org.osflash.signals.Signal;
	import org.puremvc.as3.interfaces.INotifier;
	import org.puremvc.as3.interfaces.ISignalCommand;
	import org.puremvc.as3.patterns.observer.Notifier;

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
