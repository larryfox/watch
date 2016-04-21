extension String {
    func removePrefix(prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self[prefix.endIndex..<self.endIndex]
        } else {
            return self
        }
    }
}
