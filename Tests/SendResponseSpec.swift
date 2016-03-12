import Spectre
import Inquiline
@testable import Requests


func describeSendRequest() {
  describe("Sending a request") {
    var outSocket: Socket!
    var inSocket: Socket!

    $0.before {
      let pipe = try! Socket.pipe()
      inSocket = pipe[0]
      outSocket = pipe[1]
    }

    $0.it("sends the HTTP request to the server") {
      let request = Request(method: "GET", path: "/path", headers: [], content: "Hello World")
      sendRequest(outSocket, request: request)

      let message = String.fromCString((try inSocket.read(512)) + [0])
      try expect(message) == "GET /path HTTP/1.1\r\n\r\nHello World"
    }
  }
}
