import Inquiline
import Nest
import Spectre
@testable import Requests


func describeHTTPRequest() {
  describe("HTTP Request") {
    var outSocket: Socket!
    var inSocket: Socket!

    $0.before {
      let pipe = try! Socket.pipe()
      inSocket = pipe[0]
      outSocket = pipe[1]
    }

    $0.it("can send a request") {
      let request = Request(method: "GET", path: "/test", headers: [("Test-Header", "Test Value")], content: "testing")
      sendRequest(outSocket, request: request)

      let requestString = String.fromCString(try inSocket.read(2048) + [0])
      try expect(requestString) == "GET /test HTTP/1.1\r\nTest-Header: Test Value\r\n\r\ntesting"
    }
  }
}
