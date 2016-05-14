import Foundation

func async(_ routine: () -> ()) {
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        routine)
}

func async(_ routine: @autoclosure(escaping) () -> ()) {
    async(routine as () -> ())
}
