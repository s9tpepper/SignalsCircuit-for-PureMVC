package org.signalscircuit
{
	import mx.core.UIComponent;
	import mx.core.IVisualElementContainer;
	import flash.events.IEventDispatcher;
	import flash.display.Loader;
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
		 * 
		 * @param signal A Signal object to check if it has been registered with an ISignalCommand.
		 */
		function hasSignalCommand( signal:Signal ):Boolean;
		/**
		* When a ISignalsCircuitApplication has finished loading a ISignalsCircuitComponent object it should
		* use this method to register the component as an ISignalsCircuitComponent to be able to send and
		* receive signals from it.  The Loader object that loaded the component is passed into the method
		* to register it.
		* 
		* @param uri A unique resource identifier for the component.  Typically a relative path to a ISignalsCircuitComponent.swf.
		* @param component A Loader object that has loaded into its content property a SWF that implements ISignalsCircuitComponent
		*/
		function registerComponent( uri:String, component:Loader ):void;
		/**
		* Used to unregister a component and unload it to prepare it for garbage collection.
		* 
		* @param uri A unique resource identifier for the component.  Typically a relative path to a ISignalsCircuitComponent.swf.
		*/
		function removeComponent( uri:String ):void;
		/**
		* Checks if a component has been registered by its uri String.
		* 
		* @param uri A unique resource identifier for the component.  Typically a relative path to a ISignalsCircuitComponent.swf.
		*/
		function hasComponent( uri:String ):Boolean;
		/**
		* This method is implemented to provide a mechanism for loading a component, typically from a 
		* remote URL location.  Before sending the success Signal this method makes sure to run
		* the registerComponent() method for you.  Loading the SWF and calling the registerComponent()
		* method can be done manually, this method just does it for you and dispatches the Signal
		* object that is passed in as the success Signal or the failure Signal if something fails.
		* 
		* @param uri A unique resource identifier for the component.  Typically a relative path to a ISignalsCircuitComponent.swf.
		* @param success A Signal to dispatch if the component is loaded successfully.  The success Signal should expect a Loader object.
		* @param failure A Signal to dispatch if the component load fails.  The failure Signal should expect an Event object from the failure.
		*/
		function loadComponent( uri:String, success:Signal=null, failure:Signal=null ):void;
		/**
		* This method is used to validate that the Loader's content implements the ISignalsCircuitComponent interface
		* so that the ISignalsCircuit implementation may communicate with the component as expected.
		* 
		* @param component A Loader object that has loaded into its content property a SWF that implements ISignalsCircuitComponent
		*/
		function validateComponent( component:Loader ):Boolean;
		/**
		* Used by ISignalsCircuitApplication implementations to register signals that
		* it expects to possibly receive from a component.  The Loader object that loaded the 
		* component is passed into the method to register it.
		* 
		* @param name The String to register the Signal object to.
		* @param signal The Signal object to register to the name.
		*/
		function registerComponentSignalNameToReceive( name:String, signal:Signal ):void;
		/**
		* Used by ISignalsCircuitComponent implementations to register signals that
		* it expects to possibly receive from the application.  The Loader object that loaded 
		* the component is passed into the method to register it.
		* 
		* @param name The String to register the Signal object to.
		* @param signal The Signal object to register to the name.
		*/
		function registerApplicationSignalNameToReceive( name:String, signal:Signal ):void;
		/**
		* Signals that need to be sent to components by the application can be registered with the 
		* <code>registerApplicationToComponentSignal()</code> method.  Whenever this Signal is dispatched its name and arguments will
		* be sent to all components.  If the component has registered a Signal with SignalsCircuit's <code>registerApplicationSignalNameToReceive()</code>
		* the component can react to a Signal defined by the component that expects the same arguments as the application
		* sent.  Objects mapped in the arguments array are encoded/decoded using the AMF protocol to go from one application
		* sandbox to the other. 
		*/
		function registerApplicationToComponentSignal( signalName:String, signal:Signal ):void;
		/**
		* Signals that need to be sent to the application from a component are registered to <code>registerComponentToApplicationSignal()</code>
		* method.  This will ensure that each time the Signal is dispatched the application is notified.
		*/
		function registerComponentToApplicationSignal( signalName:String, signal:Signal, sharedEvents:IEventDispatcher ):void;
		/**
		* When a ISignalsCircuitApplication has finished loading a ISignalsCircuitComponent object it should
		* use this method to register the component as an ISignalsCircuitComponent to be able to send and
		* receive signals from it if the component is a Flex based component, mx or spark.  The Loader object that loaded the component is passed into the method
		* to register it.
		* 
		* @param uri A unique resource identifier for the component.  Typically a relative path to a ISignalsCircuitComponent.swf.
		* @param component A Loader object that has loaded into its content property a SWF that implements ISignalsCircuitComponent
		*/
		function registerFlexComponent( uri:String, component:Loader ):void;
		/**
		* This method is used to validate that the Loader's content implements the ISignalsCircuitComponent interface
		* so that the ISignalsCircuit implementation may communicate with the component as expected when the loaded
		* component is either an MX or Spark component.
		* 
		* @param component A Loader object that has loaded into its content property a SWF that implements ISignalsCircuitComponent
		*/
		function validateFlexComponent(component:Loader):Boolean;
		/**
		* This method is implemented to provide a mechanism for loading a Spark based component, typically from a 
		* remote URL location.  Before sending the success Signal this method makes sure to run
		* the registerComponent() method for you.  Loading the SWF and calling the registerComponent()
		* method can be done manually, this method just does it for you and dispatches the Signal
		* object that is passed in as the success Signal or the failure Signal if something fails.
		* 
		* @param uri A unique resource identifier for the component.  Typically a relative path to a ISignalsCircuitComponent.swf.
		* @param success A Signal to dispatch if the component is loaded successfully.  The success Signal should expect a Loader object.
		* @param failure A Signal to dispatch if the component load fails.  The failure Signal should expect an Event object from the failure.
		*/
		function loadSparkComponent(uri:String, parent:IVisualElementContainer, success:Signal=null, failure:Signal=null):void;
		/**
		* This method is implemented to provide a mechanism for loading an MX based component, typically from a 
		* remote URL location.  Before sending the success Signal this method makes sure to run
		* the registerComponent() method for you.  Loading the SWF and calling the registerComponent()
		* method can be done manually, this method just does it for you and dispatches the Signal
		* object that is passed in as the success Signal or the failure Signal if something fails.
		* 
		* @param uri A unique resource identifier for the component.  Typically a relative path to a ISignalsCircuitComponent.swf.
		* @param success A Signal to dispatch if the component is loaded successfully.  The success Signal should expect a Loader object.
		* @param failure A Signal to dispatch if the component load fails.  The failure Signal should expect an Event object from the failure.
		*/
		function loadMXComponent(uri:String, parent:UIComponent, success:Signal=null, failure:Signal=null):void;
		
		
	}
}
