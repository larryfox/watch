extension String {
    func removePrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self[prefix.endIndex..<self.endIndex]
        } else {
            return self
        }
    }
}
