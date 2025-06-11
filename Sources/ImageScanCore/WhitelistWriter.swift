//
//  WhitelistWriter.swift
//  ImageScanTool
//
//  Created by john on 2025/6/10.
//

import Foundation

public struct WhitelistWriter {
    public static func write(_ whitelist: Set<String>, to outputPath: String) throws {
        let sorted = whitelist.sorted()
        let content = sorted.joined(separator: "\n") + "\n"
        try content.write(toFile: outputPath, atomically: true, encoding: .utf8)
    }
}
