package org.signalscircuit
{
	import flash.utils.getQualifiedClassName;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.controls.SWFLoader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import org.signalscircuit.puremvc.as3.patterns.observer.ComponentSharedSignalObserver;
	import org.signalscircuit.puremvc.as3.patterns.observer.SharedSignalObserver;
	import mx.utils.Base64Encoder;
	import flash.utils.ByteArray;
	import mx.utils.Base64Decoder;
	import org.signalscircuit.component.SignalsCircuitComponentEvent;
	import flash.utils.describeType;
	import org.signalscircuit.component.SignalsCircuitComponentLoader;
	import flash.display.Loader;
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
		/**
		* Keeps track of registered ISignalsCircuitComponent object Loader instances.
		*/
		private var _components:Dictionary;
		private var _activeComponentLoaders:Array = new Array();
		private var _signalsFromApplication:Dictionary;
		private var _signalsFromComponents:Dictionary;
		private var _signalsToComponents:Dictionary;
		private var _signalsToApplication:Dictionary;
		
		// Singleton instance
		protected static var instance : ISignalsCircuit;
		// Message Constants
		protected const SINGLETON_MSG:String = "SignalsCircuit Singleton already constructed!";
		/**
		 * @Constructor
		 */
		{
		instance = new SignalsCircuit();
		}
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
			_observerMap			= new Dictionary();
			_circuit				= new Dictionary();
			_components				= new Dictionary();
			_signalsFromApplication	= new Dictionary();
			_signalsFromComponents	= new Dictionary();
			_signalsToComponents	= new Dictionary();
			_signalsToApplication	= new Dictionary();
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
				_observerMap[signal]		= new SignalObserver(signal, this);
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
		
		
		
		////////////////////////////////////////////////////////////
		//
		// Multi-core PureMVC-as3Signals api methods.
		//
		////////////////////////////////////////////////////////////
		/**
		* @inheritDoc
		*/
		public function registerComponent( uri:String, component:Loader ):void
		{
			if (!validateComponent(component))
				throw new Error("You must register Loader objects where the content property contains a SWF file that implements org.signalscircuit.component.ISignalsCircuitComponent");
			
			if (!_components[uri])
			{
				_components[uri] = component;

				component.contentLoaderInfo.sharedEvents.addEventListener(SignalsCircuitComponentEvent.COMPONENT_TO_APPLICATION, _handleComponentToApplicationEvent, false, 0, true);
			}
		}
		/**
		* Handles events from the sharedEvents object and relays the signal.
		*/		private function _handleComponentToApplicationEvent(event:Event):void
		{
			const signal:Signal = _signalsFromComponents[event['signalName']];
			// If a Signal has been assigned for this signalName from components, dispatch
			if (signal)
			{
				const base64Decoder:Base64Decoder = new Base64Decoder();
				base64Decoder.decode(event['arguments']);
				const byteArray:ByteArray = base64Decoder.toByteArray();
				const arguments:Array = byteArray.readObject();
				signal.dispatch.apply(null, arguments);
			}
		}
		/**
		* @inheritDoc
		*/
		public function removeComponent( uri:String ):void
		{
			var component:Loader = _components[uri];
			if (component)
			{
				component.contentLoaderInfo.sharedEvents.removeEventListener(SignalsCircuitComponentEvent.COMPONENT_TO_APPLICATION, _handleComponentToApplicationEvent);
				delete _components[uri];
			}
		}
		/**
		* @inheritDoc
		*/
		public function hasComponent( uri:String ):Boolean
		{
			return (_components[uri]) ? true : false;
		}
		/**
		* @inheritDoc
		*/
		public function loadComponent( uri:String, success:Signal=null, failure:Signal=null ):void
		{
			if (!hasComponent(uri))
			{
				_activeComponentLoaders.push(new SignalsCircuitComponentLoader(_activeComponentLoaders, uri, success, failure));
			}
			else
				throw new Error("This uri already has a component registered.");
		}
		/**
		* @inheritDoc
		*/
		public function loadMXComponent(uri:String, parent:UIComponent, success:Signal=null, failure:Signal=null):void
		{
			if (!hasComponent(uri))
			{
				const uic:UIComponent = new UIComponent();
				const loader:SignalsCircuitComponentLoader = new SignalsCircuitComponentLoader(_activeComponentLoaders, uri, success, failure, true);
				
				uic.addChild(loader);
				parent.addChild(uic);
				uic.alpha = 0;
				
				_activeComponentLoaders.push(loader);
			}
			else
				throw new Error("This uri already has a component registered.");
		}
		/**
		* @inheritDoc
		*/
		public function loadSparkComponent(uri:String, parent:IVisualElementContainer, success:Signal=null, failure:Signal=null):void
		{
			if (!hasComponent(uri))
			{
				const uic:UIComponent = new UIComponent();
				const loader:SignalsCircuitComponentLoader = new SignalsCircuitComponentLoader(_activeComponentLoaders, uri, success, failure, true);
				
				uic.addChild(loader);
				parent.addElement(uic);
				uic.alpha = 0;
				
				_activeComponentLoaders.push(loader);
			}
			else
				throw new Error("This uri already has a component registered.");
		}
		/**
		* @inheritDoc
		*/
		public function validateComponent( component:Loader ):Boolean
		{
			const componentInfo:XML = describeType(component.content);
			const interfaces:XMLList = componentInfo.implementsInterface.(@type == "org.signalscircuit.component::ISignalsCircuitComponent");
			return (interfaces.length() > 0) ? true : false;
		}
		/**
		* @inheritDoc
		*/
		public function validateFlexComponent(component:Loader):Boolean
		{
			const componentInfo:XML = describeType(component.content['application']);
			const interfaces:XMLList = componentInfo.implementsInterface.(@type == "org.signalscircuit.component::ISignalsCircuitComponent");
			return (interfaces.length() > 0) ? true : false;
		}
		/**
		* @inheritDoc
		*/
		public function registerFlexComponent( uri:String, component:Loader ):void
		{
			if (!validateFlexComponent(component))
				throw new Error("You must register Loader objects where the content property contains a SWF file that implements org.signalscircuit.component.ISignalsCircuitComponent");
			
			if (!_components[uri])
			{
				_components[uri] = component;
				component.contentLoaderInfo.sharedEvents.addEventListener(SignalsCircuitComponentEvent.COMPONENT_TO_APPLICATION, _handleComponentToApplicationEvent, false, 0, true);
			}
		}
		/**
		* @inheritDoc
		*/
		public function registerComponentSignalNameToReceive( signalName:String, signal:Signal ):void
		{
			if (!_signalsFromComponents[signalName])
			{
				_signalsFromComponents[signalName] = signal;
			}
		}
		/**
		* @inheritDoc
		*/
		public function registerApplicationSignalNameToReceive( signalName:String, signal:Signal ):void
		{
			if (!_signalsFromApplication[signalName])
			{
				_signalsFromApplication[signalName] = signal;
			}
		}
		/**
		* @inheritDoc
		*/
		public function registerApplicationToComponentSignal( signalName:String, signal:Signal ):void
		{
			if (!_signalsToComponents[signalName])
			{
				_signalsToComponents[signalName] = new SharedSignalObserver(signalName, signal, this);
			}
		}
		/**
		* @inheritDoc
		*/
		public function registerComponentToApplicationSignal( signalName:String, signal:Signal, sharedEvents:IEventDispatcher ):void
		{
			if (!_signalsToApplication[signalName])
			{
				_signalsToApplication[signalName] = new ComponentSharedSignalObserver(signalName, signal, sharedEvents, this);
			}
		}
		/**
		* Dispatches a Signal in all loaded components by Signal name.  If the ISignalsCircuitComponent has a 
		* Signal registered to the dispatched Signal name the component dispatches its mapped Signal object to
		* respond to the message from the application.  Typically called by SharedSignalObserver
		* triggered by Signals dispatched that have been registered with registerApplicationToComponentSignal().
		*/
		public function dispatchSignalToComponents(signalName:String, arguments:Array):void
		{
			var contentLoader:Loader;
			for (var key:String in _components)
			{
				contentLoader = _components[key];
				if (contentLoader)
				{
					var loadedContent:Object = contentLoader.content;
					
					const byteArray:ByteArray = new ByteArray();
					byteArray.writeObject(arguments);
					const base64Encoder:Base64Encoder = new Base64Encoder();
					base64Encoder.encodeBytes(byteArray);
					
					const loadedType:String = getQualifiedClassName(loadedContent);
					if (loadedType.lastIndexOf("mx_managers_SystemManager") == -1)
					{
						loadedContent.receiveSignalFromApplication(signalName, base64Encoder.drain());
					}
					else
					{
						// This is most likely a Flex component, use the application property.
						try
						{
							loadedContent['application'].receiveSignalFromApplication(signalName, base64Encoder.drain());
						}
						catch (e:Error) {}
					}
				}
			}
		}
		/**
		* This method sends a signal through from a component application through to the
		* application that loaded the component.
		*/
		public function dispatchSignalToApplication(signalName:String, arguments:Array, sharedEvents:IEventDispatcher):void
		{
			const byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(arguments);
			const base64Encoder:Base64Encoder = new Base64Encoder();
			base64Encoder.encodeBytes(byteArray);
			
			const signalsCircuitComponentEvent:SignalsCircuitComponentEvent = new SignalsCircuitComponentEvent(SignalsCircuitComponentEvent.COMPONENT_TO_APPLICATION);
			signalsCircuitComponentEvent.arguments = base64Encoder.drain();
			signalsCircuitComponentEvent.signalName = signalName;
			
			sharedEvents.dispatchEvent(signalsCircuitComponentEvent);
		}
		/**
		* This method is used by ISignalsCircuitApplication implementations to trigger dispatching a Signal
		* by its registered name in a component.
		* 
		* @param signalName The name of the Signal that the application is sending out.
		* @param arguments An array of arguments to dispatch with the Signal if the component has a Signal for that name registered in a base64 encoded AMF String.
		*/
		public function receiveSignalFromApplication(signalName:String, arguments:String):void
		{
			if (_signalsFromApplication[signalName])
			{
				const base64Decoder:Base64Decoder = new Base64Decoder();
				base64Decoder.decode(arguments);
				const byteArray:ByteArray = base64Decoder.toByteArray();
				const args:Array = byteArray.readObject();
				
				const signal:Signal = _signalsFromApplication[signalName];
				if (signal)
					signal.dispatch.apply(null, args);
			}
		}
	}
}