# Requests

Simple synchronous HTTP client in Swift.

## Usage

```swift
let response = try get("http://httpbin.org/get")
```

### Missing Features

I wouldn't recommend using this for anything serious, it misses dozens of
features and which I don't intend to add as my use-case is very limited. When
considering the correct approach, this code probably takes a shortcut.

- HTTPS (SSL/TLS)
- IPv6
- Dozens of other things

Pull requests are however very welcome if you are interested in adding any of
these missing features or improving the general quality of the code.
