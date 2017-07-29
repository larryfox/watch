import Foundation

let globalQueue = DispatchQueue.global()

func async(_ routine: @escaping () -> ()) {
    globalQueue.async(execute: routine)
}

func async(_ routine: @autoclosure @escaping () -> ()) {
    async(routine as () -> ())
}
