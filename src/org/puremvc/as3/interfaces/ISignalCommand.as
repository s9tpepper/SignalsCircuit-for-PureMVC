package org.puremvc.as3.interfaces
{
	import org.osflash.signals.Signal;
	/**
	 * @author Omar Gonzalez
	 */
	public interface ISignalCommand
	{
		/**
		 * Executes the command, passing in the Signal object that
		 * triggered the command and the arguments passed in as an
		 * Array object.
		 * 
		 * @param signal Signal object that triggered the command.
		 * @param args Array of arguments dispatched with the Signal.
		 */
		function execute(signal:Signal, args:Array):void;
	}
}
