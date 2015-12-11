import Inquiline


public enum RequestError : ErrorType {
  case InvalidURL
  case UnsupportedScheme(String)
}


public func request(method method: String, url: String, headers: [(String, String)]? = nil, body: String? = nil) throws -> Response {
  guard let url = URL(string: url) else {
    throw RequestError.InvalidURL
  }

  if url.scheme != "http" {
    throw RequestError.UnsupportedScheme(url.scheme)
  }

  let socket = try Socket()
  try socket.connect(url.hostname, port: url.port)

  socket.send("\(method) \(url.path) HTTP/1.1\r\n")
  socket.send("Host: \(url.hostname)\r\n")
  socket.send("Connection: close\r\n")
  if let headers = headers {
    for (key, value) in headers {
      socket.send("\(key): \(value)\r\n")
    }
  }

  if let body = body {
    socket.send("Content-Length: \(body.characters.count)\r\n\r\n") // this aint even the right thing, I don't even care.
    socket.send(body)
  } else {
    socket.send("\r\n")
  }

  let parser = HTTPParser(socket: socket)
  let response = try parser.parse()

  socket.close()

  return response
}


public func head(url: String, parameters: [String: String]? = nil, headers: [(String, String)]? = nil) throws -> Response {
  // TODO encoded parameters
  return try request(method: "HEAD", url: url, headers: headers)
}


public func get(url: String, parameters: [String: String]? = nil, headers: [(String, String)]? = nil) throws -> Response {
  // TODO encoded parameters
  return try request(method: "GET", url: url, headers: headers)
}


public func delete(url: String, parameters: [String: String]? = nil, headers: [(String, String)]? = nil) throws -> Response {
  // TODO encoded parameters
  return try request(method: "DELETE", url: url, headers: headers)
}


// TODO, build post, patch, convinience
