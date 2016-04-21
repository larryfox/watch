import Foundation

func go(_ routine: () -> ()) {
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        routine)
}

func go(@autoclosure(escaping) _ routine: () -> ()) {
    go(routine as () -> ())
}
