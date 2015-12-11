import PackageDescription


let package = Package(
  name: "RequestsTests",
  dependencies: [
    .Package(url: "https://github.com/kylef/Spectre.git", majorVersion: 0, minor: 5),
  ]
)
