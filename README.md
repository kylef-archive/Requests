# Requests

Simple synchronous HTTP client in Swift.

## Usage

```swift
let response = try get("http://httpbin.org/get")

print(response.headers)
print(response.body)
```

```swift
let response = try post("http://httpbin.org/post", content: "Hello World")

print(response.headers)
print(response.body)
```

### Missing Features

I wouldn't recommend using this for anything serious, it misses many
features. When considering the correct approach, this library
probably takes a shortcut.

It misses at least the following:

- HTTPS (SSL/TLS)
- IPv6
- Handling of redirects
- Dozens of other things

Pull requests are however very welcome if you are interested in adding any of
these missing features.
