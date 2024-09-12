// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "TJSpinny",
    platforms: [.iOS(.v12), .tvOS(.v13), .macCatalyst(.v13)],
    products: [
        .library(
            name: "TJSpinny",
            targets: ["TJSpinny"]
        )
    ],
    targets: [
        .target(
            name: "TJSpinny",
            path: ".",
            sources: ["UIViewController+Loading.m"],
            publicHeadersPath: ".",
			resources: []
        )
    ]
)
