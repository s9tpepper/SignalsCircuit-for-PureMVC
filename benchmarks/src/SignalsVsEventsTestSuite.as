package
{
	import flash.utils.getTimer;
	import signalscircuit.TestSignalCommand;
	import org.puremvc.as3.core.SignalsCircuit;
	import puremvc.TestCommand;
	import org.puremvc.as3.patterns.facade.Facade;
	import com.gskinner.performance.MethodTest;
	import com.gskinner.performance.TestSuite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Ross
	 */
	public class SignalsVsEventsTestSuite extends TestSuite{
		
		private var signal:Signal = new Signal();
		private var deluxeSignal:DeluxeSignal = new DeluxeSignal(this);
		
		private var eventType:String = "testEvent";
		private var eventDispatcher:EventDispatcher = new EventDispatcher();
		private var event:Event = new Event(eventType);
		private var facade:Facade = Facade.getInstance() as Facade;
		
		private var signal1:Signal = new Signal();
		private var signalCircuit:SignalsCircuit = SignalsCircuit.getInstance() as SignalsCircuit;
		
		
		public var loops:uint = 100000;
		private var _funcs:Array;
		
		public function SignalsVsEventsTestSuite(totalListeners:uint = 0) {
			name = "Signal Dispatching vs Event Dispatching :: Dispatching 100000 times to " + totalListeners + " Listener(s) -- ";
			description = "Test of dispatching times of a signal vs a event with various types of listeners";
			
			tareTest = new MethodTest(tare);
			iterations = 5;
			_funcs = [];
			for (var i:int = 0; i < totalListeners; i++) {
				_funcs.push(function():void { } );
			}
			
			var facadeNotes:Array = [];
			for (i = 0; i < totalListeners; i++) {
				facadeNotes.push(getTimer().toString());
			}
			
			tests = [
				new MethodTest(signalDispatch, _funcs, "Signal", 0, 1, "Signal Dispatching"),
				new MethodTest(deluxeSignalDispatch, _funcs, "DeluxeSignal", 0, 1, "DeluxeSignal Dispatching"),
				new MethodTest(eventDispatch, _funcs, "Event", 0, 1, "Event Dispatching"),
				new MethodTest(noteDispatch, facadeNotes, "PureMVC Notifications", 0, 1, "Notification Dispatching"),
				new MethodTest(pureMVCSignalDispatch, _funcs, "SignalsCircuit for PureMVC", 0, 1, "SignalsCircuit Dispatching")
			];
			
		}
		private function tare():void{
			for (var i:uint=0; i<loops; i++) {
			}
		}
		
		private function pureMVCSignalDispatch(...args):void
		{
			var i:Number;
			if (args && args.length > 0)
			{
				// The SignalsCircuit.registerSignal method only takes 1 command reference
				// per signal, so to test with more than 1 event handler four other callback
				// methods are added directly to the signal, since this is still a valid 
				// and probable use case of the Signal object.
				signalCircuit.registerSignal(signal1, TestSignalCommand);
				
				if (args.length > 1)
				{
					for (i = 1; i < args.length; i++)
					{
						signal1.add(_funcs[i]);
					}
				}
			}
			
			for (i = 0; i < loops; i++) {
				signal1.dispatch();
			}

			signalCircuit.removeCommand(signal1);
		}
		
		private function signalDispatch(...args):void {
			var i:uint;
			for (i = 0; i < args.length; i++) {
				signal.add(args[i]);
			}
			
			for (i = 0; i < loops; i++) {
				signal.dispatch();
			}
			
			signal.removeAll();
		}
		
		private function deluxeSignalDispatch(...args):void {
			var i:uint;
			for (i = 0; i < args.length; i++) {
				deluxeSignal.add(args[i]);
			}
			
			for (i = 0; i < loops; i++) {
				deluxeSignal.dispatch();
			}
			
			deluxeSignal.removeAll();
		}
		
		private function eventDispatch(...args):void {
			var i:uint;
			for (i = 0;  i < args.length; i++) {
				eventDispatcher.addEventListener(eventType, args[i]);
			}
			
			for (i = 0; i < loops; i++) {
				eventDispatcher.dispatchEvent(event);
			}
			
			for (i = 0; i < args.length; i++) {
				eventDispatcher.removeEventListener(eventType, args[i]);
			}
		}
		
		private function noteDispatch(... args):void
		{
			var i:uint;
			for (i = 0; i < args.length; i++) {
				facade.registerCommand(args[i], TestCommand);
			}
			
			for (i = 0; i < loops; i++) {
				for (var j:Number = 0; j < args.length; j++) {
					facade.sendNotification(args[j]);
				}
			}

			for (i = 0; i < args.length; i++) {
				facade.removeCommand(args[i]);
			} 
		}
		
		
	}

}