package mvc.view.mediators {
	import mvc.events.SystemEvent;
	import mvc.view.components.ContentView;

	import org.robotlegs.mvcs.Mediator;

	import flash.events.Event;

	/**
	 * 
	 */
	public class ContentViewMediator extends Mediator {
		[Inject]
		public var view : ContentView;

		// --------------------------------------------------------------------------
		//
		// Initialization
		//
		// --------------------------------------------------------------------------
		/**
		 * Avoid doing work in the constructor!
		 * onRegister() is the place to do things. 
		 * 
		 */
		public function ContentViewMediator() {
		}

		// --------------------------------------------------------------------------
		//
		// Overridden API
		//
		// --------------------------------------------------------------------------
		/**
		 * Initialize the view and register for events. 
		 * 
		 */
		override public function onRegister() : void {
			view.main();
			eventMap.mapListener(view, ContentView.LOAD_MODULE, handleLoad);
			eventMap.mapListener(eventDispatcher, SystemEvent.LOADED_MODULE, handleLoaded);
		}

		// --------------------------------------------------------------------------
		//
		// Eventhandling
		//
		// --------------------------------------------------------------------------
		private function handleLoad(event : Event) : void {
			dispatch(new SystemEvent(SystemEvent.LOAD_MODULE, "GCTestModule.swf"));
		}

		private function handleLoaded(event : SystemEvent) : void {
			view.addTreeModule(event.body);
		}
	}
}