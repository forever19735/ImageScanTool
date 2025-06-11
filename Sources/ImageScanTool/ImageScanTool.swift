// The Swift Programming Language
// https://docs.swift.org/swift-book
import ImageScanCore
import Foundation
import ArgumentParser

@main
struct ImageScanTool: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "🔍 Scan Swift files for dynamic image usages (UIImage, Image, etc.) and generate a whitelist."
    )

    @Option(name: .shortAndLong, help: "Path to source code directory (e.g. ./Sources)")
    var source: String

    @Option(name: .shortAndLong, help: "Path to output whitelist file")
    var output: String

    func run() throws {
        print("📁 Scanning directory: \(source)")
        let scanner = Scanner()
        let whitelist = scanner.scanDirectory(at: source)

        try WhitelistWriter.write(whitelist, to: output)
        print("✅ Done. Found \(whitelist.count) dynamic image references. Saved to \(output)")
    }
}
