import class Foundation.NSURLComponents

struct URL {
  let scheme: String
  let hostname: String
  let port: Int16
  let path: String

  init?(string: String) {

    guard 
      let comps = NSURLComponents(string: string),
      let scheme = comps.scheme,
      let host = comps.host,
      let path = comps.path
      else { 
        return nil 
      }
    let port = Int16(Int(comps.port ?? 80))

    self.scheme = scheme
    self.hostname = host
    self.port = port
    self.path = path
  }
}
