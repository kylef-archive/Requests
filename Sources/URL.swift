struct URL {
  let scheme: String
  let hostname: String
  let port: Int16
  let path: String

  init?(string: String) {
    let parts = string.split("://", maxSplit: 1)
    if parts.count != 2 {
      scheme = ""
      hostname = ""
      port = 80
      path = ""
      return nil
    }

    scheme = parts[0]
    let parts1 = parts[1].split("/")
    if parts1.count < 2 {
      hostname = ""
      port = 80
      path = ""
      return nil
    }

    path = "/" + parts1[1..<parts1.count].joinWithSeparator("/")

    let address = parts1[0]

    let parts2 = address.split(":", maxSplit: 1)
    if parts2.count > 1 {
      hostname = parts2[0]
      if let port = Int16(parts2[1]) {
        self.port = port
      } else {
        port = 80
        return nil
      }
    } else {
      hostname = address
      port = 80
    }
  }
}
