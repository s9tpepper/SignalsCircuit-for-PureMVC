package org.signalscircuit.puremvc.as3.patterns.command
{
	import org.osflash.signals.Signal;
	import org.signalscircuit.puremvc.as3.interfaces.ISignalCommand;

	/**
	 * @author Omar Gonzalez
	 */
	public class MacroSignalCommand extends SimpleSignalCommand
	{
		/**
		 * Vector of ISignalCommand objects set as sub commands to this MacroSignalCommand.
		 */
		private var _subCommands:Array;
		
		public function MacroSignalCommand()
		{
			_subCommands = new Array();
			initializeMacroCommand();
		}
		/**
		 * Initialize the <code>MacroSignalCommand</code>.
		 * 
		 * <P>
		 * In your subclass, override this method to 
		 * initialize the <code>MacroSignalCommand</code>'s <i>SubCommand</i>  
		 * list with <code>ISignalCommand</code> class references like 
		 * this:</P>
		 * 
		 * <listing>
		 *		// Initialize MyMacroSignalCommand
		 *		override protected function initializeMacroCommand( ) : void
		 *		{
		 *			addSubCommand( com.me.myapp.controller.FirstCommand );
		 *			addSubCommand( com.me.myapp.controller.SecondCommand );
		 *			addSubCommand( com.me.myapp.controller.ThirdCommand );
		 *		}
		 * </listing>
		 * 
		 * <P>
		 * Note that <i>SubCommand</i>s may be any <code>ISignalCommand</code> implementor,
		 * <code>MacroSignalCommand</code>s or <code>SimpleSignalCommand</code>s are both acceptable.
		 */
		protected function initializeMacroCommand():void
		{
		}
		/**
		 * Add a <i>SubCommand</i>.
		 * 
		 * <P>
		 * The <i>SubCommands</i> will be called in First In/First Out (FIFO)
		 * order.</P>
		 * 
		 * @param commandClassRef a reference to the <code>Class</code> of the <code>ISignalCommand</code>.
		 * @param cached A Boolean flag to set whether the command is pre-instantiated.
		 */
		protected function addSubCommand(commandClassRef:Class, cached:Boolean=true):void
		{
			if (cached)
			{
				_subCommands.push(new commandClassRef());
			}
			else
			{
				_subCommands.push(commandClassRef);
			}
		}
		/** 
		 * @inheritDoc
		 */
		final override public function execute(signal:Signal, args:Array):void
		{
			while ( _subCommands.length > 0)
			{
				var commandClassRef:*				= _subCommands.shift();
				var commandInstance:ISignalCommand	= (commandClassRef is Class) ? new commandClassRef() : commandClassRef;
				commandInstance.execute(signal, args);
			}
		}
	}
}
