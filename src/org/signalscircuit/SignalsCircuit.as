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
		 * Keeps track of registered signals.
		 */
		private var _circuit:Dictionary;
		/**
		 * Keeps track of whether a signal command was cached or not.
		 */
		private var _isSignalCached:Dictionary;
		// Singleton instance
		protected static var instance : ISignalsCircuit;
		// Message Constants
		protected const SINGLETON_MSG:String = "SignalsCircuit Singleton already constructed!";
		/**
		 * Dictionary of SignalObserver objects.
		 */
		private var _observerMap:Dictionary;
		
		/**
		 * @Constructor
		 */
		public function SignalsCircuit()
		{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			_initializeSignalCircuit();
		}
		/**
		 * Initializes the SignalsCircuit object.
		 */
		private function _initializeSignalCircuit():void
		{
			_observerMap = new Dictionary();
			_circuit = new Dictionary();
			_isSignalCached = new Dictionary();
		}
		/**
		 * Registers a SignalObserver object for a Signal object.
		 */
		private function _registerObserver( signal:Signal, signalObserver:SignalObserver ):void
		{
			var observers:Vector.<SignalObserver> = _observerMap[ signal ];
			if (observers)
			{
				observers.push( signalObserver );
			} 
			else
			{
				var vec:Vector.<SignalObserver> = new Vector.<SignalObserver>();
					vec.push(signalObserver);
				_observerMap[ signal ] = vec;	
			}
		}
		/**
		 * Registers a Signal object and a ISignalCommand object together.
		 */
		public function registerSignal(signal:Signal, commandClassRef:Class, cache:Boolean = true):void
		{
			if (!_circuit[ signal ]) 
			{
				_circuit[signal]			= (cache) ? new commandClassRef() : commandClassRef;
				_isSignalCached[signal]		= cache;
				_registerObserver(signal, new SignalObserver(signal, executeSignalCommand, this));
			}
		}
		/**
		 * Executes the Command associated with a Signal object.
		 */
		public function executeSignalCommand(signal:Signal, args:Array):void
		{
			var commandInstance:ISignalCommand;
			if (_isSignalCached[signal])
			{
				commandInstance = _circuit[signal];
			}
			else
			{
				var commandClassRef:Class = _circuit[signal];
				
				if (commandClassRef == null) return;
				
				commandInstance = new commandClassRef();
			}
			
			commandInstance.execute(signal, args);
		}
		/**
		 * Removes handlers from the signal.
		 */
		public function removeCommand(signal:Signal):void
		{
			signal.removeAll();
		}
		/**
		 * <code>SignalsCircuit</code> Singleton Factory method.
		 * 
		 * @return the Singleton instance of <code>SignalsCircuit</code>
		 */
		public static function getInstance() : ISignalsCircuit
		{
			if (instance == null) instance = new SignalsCircuit();
			return instance;
		}
	}
}
