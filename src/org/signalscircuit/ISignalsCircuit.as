package org.signalscircuit
{
	import org.osflash.signals.Signal;
	/**
	 * @author Omar Gonzalez
	 */
	public interface ISignalsCircuit
	{
		/**
		 * Register a particular <code>ISignalCommand</code> class as the handler 
		 * for a particular <code>Signal</code>.
		 * 
		 * @param signal the trigger for the command it triggers.
		 * @param commandClassRef the Class of the <code>ISignalCommand</code>
		 * @param cache whether this command is cached (1 instance).
		 */
		function registerSignal( signal:Signal, commandClassRef : Class, cache:Boolean = false ) : void;
		
		/**
		 * Execute the <code>ISignalCommand</code> previously registered as the
		 * handler for <code>Signal</code>.
		 * 
		 * @param signal the <code>Signal</code> to run the associated command for.
		 */
		function executeSignalCommand( signal:Signal, args:Array ) : void;

		/**
		 * Remove a previously registered <code>ISignalCommand</code> to <code>Signal</code> mapping.
		 * 
		 * @param Signal to remove the <code>ISignalCommand</code> mapping for
		 */
		function removeCommand( signal:Signal ):void;
		
		/**
		 * Checks if the Signal has been registered with an ISignalCommand object.
		 */
		function hasSignalCommand( signal:Signal ):Boolean;
	}
}
