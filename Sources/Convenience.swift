import Nest
import Inquiline


public func head(url: String, headers: [Header]? = nil) throws -> Response {
  return try request(method: "HEAD", url: url, headers: headers)
}


public func get(url: String, headers: [Header]? = nil) throws -> Response {
  return try request(method: "GET", url: url, headers: headers)
}


public func delete(url: String, headers: [Header]? = nil) throws -> Response {
  return try request(method: "DELETE", url: url, headers: headers)
}


public func post(url: String, headers: [Header]? = nil, content: String) throws -> Response {
  return try request(method: "POST", url: url, headers: headers, body: content)
}


public func put(url: String, headers: [Header]? = nil, content: String) throws -> Response {
  return try request(method: "PUT", url: url, headers: headers, body: content)
}


public func patch(url: String, headers: [Header]? = nil, content: String) throws -> Response {
  return try request(method: "PATCH", url: url, headers: headers, body: content)
}
