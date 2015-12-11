import Nest
import Inquiline


public enum RequestError : ErrorType {
  case InvalidURL
  case UnsupportedScheme(String)
}


func createRequest(method: String, path: String, hostname: String, headers: [Header], body: String? = nil) -> RequestType {
  let requestsHeaders: [Header] = [("Host", hostname), ("Connection", "close")]
  return Request(method: method, path: path, headers: requestsHeaders + headers, body: body)
}


func sendRequest(socket: Socket, request: RequestType) {
  socket.write("\(request.method) \(request.path) HTTP/1.1\r\n")
  for (key, value) in request.headers {
    socket.write("\(key): \(value)\r\n")
  }
  socket.write("\r\n")

  if let body = request.body {
    socket.write(body)
  }
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
  let request = createRequest(method, path: url.path, hostname: url.hostname, headers: headers ?? [], body: body)
  sendRequest(socket, request: request)

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
