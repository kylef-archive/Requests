import PackageDescription


let package = Package(
  name: "Requests",
  dependencies: [
    .Package(url: "https://github.com/nestproject/Inquiline.git", majorVersion: 0, minor: 2),
  ]
)
