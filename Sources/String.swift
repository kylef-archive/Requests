class Scanner {
  var content: String

  init(_ content: String) {
    self.content = content
  }

  var isEmpty: Bool {
    return content.characters.count == 0
  }

  func scan(until until: String) -> String {
    if until.isEmpty {
      return ""
    }

    var characters: [Character] = []

    while !content.isEmpty {
      let character = content.characters.first!
      content = String(content.characters.dropFirst())

      characters.append(character)

      if content.hasPrefix(until) {
        let index = content.characters.startIndex.advancedBy(until.characters.count)
        content = String(content.characters[index..<content.characters.endIndex])
        break
      }
    }

    return String(characters)
  }
}


extension String {
  func split(separator: String, maxSplit: Int = Int.max) -> [String] {
    var components: [String] = []
    let scanner = Scanner(self)
    var count = 0

    while !scanner.isEmpty || count == maxSplit {
      let scanned = scanner.scan(until: separator)
      if scanned.isEmpty && scanner.isEmpty {
        break
      }
      components.append(scanned)
      ++count
    }

    return components
  }
}
