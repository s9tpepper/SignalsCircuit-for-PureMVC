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
		/**
		 * This method is a helper function that encapsulates facade.retrieveProxy()
		 * and instead of returning an IProxy object in the method signature getProxy()
		 * returns a wildcard.  This removes the need to cast the return to stuff into
		 * a variable, but puts the responsibility on the developer to make sure they
		 * are retrieving the correct type of object or a run time error will occur.
		 * 
		 * @param proxyName The name of the Proxy instance to retrieve from the PureMVC Model cache.
		 */
		protected function getProxy(proxyName:String):*
		{
			return facade.retrieveProxy(proxyName);
		}
		/**
		 * See <code>getProxy()</code>.
		 */
		protected function gp(proxyName:String):*
		{
			return getProxy(proxyName);
		}
		/**
		 * This method is a helper function that encapsulates facade.retrieveMediator()
		 * and instead of returning an IMediator object in the method signature getMediator()
		 * returns a wildcard.  This removes the need to cast the return to stuff into
		 * a variable, but puts the responsibility on the developer to make sure they
		 * are retrieving the correct type of object or a run time error will occur.
		 * 
		 * * @param mediatorName The name of the Mediator instance to retrieve from the PureMVC View cache.
		 */
		protected function getMediator(mediatorName:String):*
		{
			return facade.retrieveMediator(mediatorName);
		}
		/**
		 * See <code>getMediator()</code>.
		 */
		protected function gm(mediatorName:String):*
		{
			return getMediator(mediatorName);
		}
	}
}
