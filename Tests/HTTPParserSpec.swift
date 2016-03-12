import Spectre
@testable import Requests


func describeHTTPParser() {
  describe("HTTP Parser") {
    var parser: HTTPParser!
    var outSocket: Socket!
    var inSocket: Socket!

    $0.before {
      let pipe = try! Socket.pipe()
      inSocket = pipe[0]
      outSocket = pipe[1]
      parser = HTTPParser(socket: inSocket)
    }

    $0.it("can parse a HTTP response") {
      outSocket.write("HTTP/1.1 200 OK\r\nContent-Length: 12\r\nConnection: close\r\nContent-Type: text/plain\r\n\r\nHello World!")

      let response = try parser.parse()
      try expect(response.status.rawValue) == 200
      try expect(response["Content-Length"]) == "12"
      try expect(response["Content-Type"]) == "text/plain"

      guard var payload = response.body else {
        throw failure("response has no payload")
      }
      var body = [CChar]()
      while let chunk = payload.next() {
        body.appendContentsOf(chunk.map({ return CChar($0) }))
      }
      body.append(0)
      try body.withUnsafeBufferPointer { buffer in
        guard let string = String.fromCString(buffer.baseAddress) else {
          throw failure("response payload is broken")
        }
        try expect(string) == "Hello World!"
      }
    }
  }
}
