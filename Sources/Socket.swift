#if os(Linux)
import Glibc

private let sock_stream = Int32(SOCK_STREAM.rawValue)

private let system_accept = Glibc.accept
private let system_bind = Glibc.bind
private let system_close = Glibc.close
private let system_listen = Glibc.listen
private let system_read = Glibc.read
private let system_send = Glibc.send
private let system_write = Glibc.write
private let system_shutdown = Glibc.shutdown
private let system_select = Glibc.select
private let system_pipe = Glibc.pipe
private let system_connect = Glibc.connect
#else
import Darwin.C

private let sock_stream = SOCK_STREAM

private let system_accept = Darwin.accept
private let system_bind = Darwin.bind
private let system_close = Darwin.close
private let system_listen = Darwin.listen
private let system_read = Darwin.read
private let system_send = Darwin.send
private let system_write = Darwin.write
private let system_shutdown = Darwin.shutdown
private let system_select = Darwin.select
private let system_pipe = Darwin.pipe
private let system_connect = Darwin.connect
#endif


@_silgen_name("fcntl") private func fcntl(descriptor: Int32, _ command: Int32, _ flags: Int32) -> Int32


struct SocketError : ErrorType, CustomStringConvertible {
  let function: String
  let number: Int32

  init(function: String = __FUNCTION__) {
    self.function = function
    self.number = errno
  }

  var description: String {
    return "Socket.\(function) failed [\(number)]"
  }
}


/// Represents a TCP AF_INET socket
class Socket {
  typealias Descriptor = Int32
  typealias Port = UInt16

  let descriptor: Descriptor

  class func pipe() throws -> [Socket] {
    var fds: [Int32] = [0, 0]
    if system_pipe(&fds) == -1 {
      throw SocketError()
    }
    return [Socket(descriptor: fds[0]), Socket(descriptor: fds[1])]
  }

  init() throws {
#if os(Linux)
    descriptor = socket(AF_INET, sock_stream, 0)
#else
    descriptor = socket(AF_INET, sock_stream, IPPROTO_TCP)
#endif
    assert(descriptor > 0)

    var value: Int32 = 1
    guard setsockopt(descriptor, SOL_SOCKET, SO_REUSEADDR, &value, socklen_t(sizeof(Int32))) != -1 else {
      throw SocketError(function: "setsockopt()")
    }
  }

  init(descriptor: Descriptor) {
    self.descriptor = descriptor
  }

  func connect(hostname: String, port: Int16) throws {
    let host = hostname.withCString { gethostbyname($0) }
    if host == nil {
      throw SocketError()
    }

    var addr = sockaddr_in()
    addr.sin_family = sa_family_t(AF_INET)
    addr.sin_port = in_port_t(htons(in_port_t(port)))
    addr.sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)
    memcpy(&addr.sin_addr, host.memory.h_addr_list[0], Int(host.memory.h_length))

    let len = socklen_t(UInt8(sizeof(sockaddr_in)))
    guard system_connect(descriptor, sockaddr_cast(&addr), len) != -1 else {
      throw SocketError()
    }
  }

  func close() {
    system_close(descriptor)
  }

  func shutdown() {
    system_shutdown(descriptor, Int32(SHUT_RDWR))
  }

  func send(output: String) {
    output.withCString { bytes in
      system_send(descriptor, bytes, Int(strlen(bytes)), 0)
    }
  }

  func write(output: String) {
    output.withCString { bytes in
      system_write(descriptor, bytes, Int(strlen(bytes)))
    }
  }

  func write(output: [UInt8]) {
    output.withUnsafeBufferPointer { bytes in
      system_write(descriptor, bytes.baseAddress, bytes.count)
    }
  }

  func read(bytes: Int) throws -> [CChar] {
    let data = Data(capacity: bytes)
    let bytes = system_read(descriptor, data.bytes, data.capacity)
    if bytes > 0 {
      return Array(data.characters[0..<bytes])
    }

    return []
  }

  private func htons(value: CUnsignedShort) -> CUnsignedShort {
    return (value << 8) + (value >> 8)
  }

  private func sockaddr_cast(p: UnsafeMutablePointer<Void>) -> UnsafeMutablePointer<sockaddr> {
    return UnsafeMutablePointer<sockaddr>(p)
  }
}
