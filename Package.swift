import PackageDescription


let package = Package(
  name: "Requests",
  dependencies: [
    .Package(url: "https://github.com/nestproject/Inquiline.git", majorVersion: 0, minor: 2),
  ],
  testDependencies: [
    .Package(url: "https://github.com/kylef/Spectre.git", majorVersion: 0),
  ]
)
