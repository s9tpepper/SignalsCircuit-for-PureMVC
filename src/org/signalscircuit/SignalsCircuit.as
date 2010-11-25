package org.signalscircuit
{
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	import org.signalscircuit.puremvc.as3.interfaces.ISignalCommand;
	import org.signalscircuit.puremvc.as3.patterns.observer.SignalObserver;
	/**
	 * @author Omar Gonzalez
	 */
	public class SignalsCircuit implements ISignalsCircuit
	{
		/**
		 * Dictionary of SignalObserver objects.
		 */
		private var _observerMap:Dictionary;
		/**
		 * Keeps track of registered signals.
		 */
		private var _circuit:Dictionary;
		// Singleton instance
		protected static var instance : ISignalsCircuit;
		// Message Constants
		protected const SINGLETON_MSG:String = "SignalsCircuit Singleton already constructed!";
		/**
		 * @Constructor
		 */
		{instance = new SignalsCircuit();}
		public function SignalsCircuit()
		{
			if (instance != null) throw Error(SINGLETON_MSG);
			_initializeSignalCircuit();
		}
		/**
		 * Initializes the SignalsCircuit object.
		 */
		private function _initializeSignalCircuit():void
		{
			_observerMap = new Dictionary();
			_circuit = new Dictionary();
		}
		/**
		 * Registers a Signal object and a ISignalCommand object together.
		 * 
		 * @param signal A Signal object to register a ISignalCommand object to.
		 * @param commandClassRef A Class reference to a sub-class of either SimpleSignalCommand or MacroSignalCommand
		 * @param cache A Boolean flag to set whether the Signal command object is cached (pre-instantiated).  For Signals that will dispatch many times this flag should be set to true to cut down on object instantiations and increase the speed performance.
		 */
		public function registerSignal(signal:Signal, commandClassRef:Class, cache:Boolean = true):void
		{
			if (!_circuit[signal]) 
			{
				_circuit[signal]			= (cache) ? new commandClassRef() : commandClassRef;
				_observerMap[signal]		= new SignalObserver(signal, executeSignalCommand, this);
			}
		}
		/**
		 * Executes the Command associated with a Signal object.
		 * This method is not intended for direct use, it is used by the
		 * SignalObserver object.
		 * 
		 * @param signal The Signal object that was heard by a SignalObserver instance.
		 * @param args An Array of arguments dispatched with the Signal object.
		 */
		public function executeSignalCommand(signal:Signal, args:Array):void
		{
			var commandInstance:ISignalCommand;
			if (_circuit[signal] is Class)
			{
				var commandClassRef:Class = _circuit[signal] as Class;
				if (commandClassRef == null) return;
				commandInstance = new commandClassRef();
			}
			else
			{
				commandInstance = _circuit[signal];
			}
			
			if (commandInstance) 
				commandInstance.execute(signal, args);
		}
		/**
		 * Removes handlers from the signal.
		 * 
		 * @param signal The Signal object to remove from the SignalsCircuit registry.
		 */
		public function removeCommand(signal:Signal):void
		{
			if (_circuit[signal])
			{
				delete _circuit[signal];
				var signalObserver:SignalObserver = _observerMap[signal] as SignalObserver;
					signalObserver.destroy();
				delete _observerMap[signal];
			}
		}
		/**
		 * Checks if the Signal object has been registered with an ISignalCommand object.
		 * 
		 * @param signal A Signal object to check if it is active in the SignalsCircuit registry.
		 */
		public function hasSignalCommand(signal:Signal):Boolean
		{ return (_circuit[signal]) ? true : false; }
		/**
		 * <code>SignalsCircuit</code> Singleton Factory method.
		 * 
		 * @return the Singleton instance of <code>SignalsCircuit</code>
		 */
		public static function getInstance():SignalsCircuit
		{ return instance as SignalsCircuit; }
	}
}