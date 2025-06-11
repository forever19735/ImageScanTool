//
//  Scanner.swift
//  ImageScanTool
//
//  Created by john on 2025/6/10.
//

import Foundation

public struct Scanner {
    public init() {}
    
    public func scanDirectory(at path: String) -> Set<String> {
        let fileManager = FileManager.default
        var whitelist: Set<String> = []

        guard let enumerator = fileManager.enumerator(atPath: path) else {
            print("❌ Failed to enumerate path: \(path)")
            return []
        }

        for case let file as String in enumerator {
            guard file.hasSuffix(".swift") else { continue }
            let fullPath = (path as NSString).appendingPathComponent(file)
            scanFile(at: fullPath, into: &whitelist)
        }

        return whitelist
    }

    private func scanFile(at path: String, into whitelist: inout Set<String>) {
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else { return }

        let pattern = try! NSRegularExpression(
            pattern: #"(UIImage|NSImage|Image)\s*\(\s*named:\s*(.+?)\)"#,
            options: []
        )

        pattern.enumerateMatches(in: content, range: NSRange(content.startIndex..., in: content)) { result, _, _ in
            guard let result = result, result.numberOfRanges > 2 else { return }

            let paramRange = result.range(at: 2)
            guard let swiftRange = Range(paramRange, in: content) else { return }

            let param = content[swiftRange].trimmingCharacters(in: .whitespacesAndNewlines)

            // 排除靜態字串 "xxx"
            if param.hasPrefix("\"") && param.hasSuffix("\"") && !param.contains("\\(") {
                return
            }

            let fullCall = (content as NSString).substring(with: result.range)
            whitelist.insert("// ⚠️ dynamic image usage: \(fullCall)")
        }
    }
}
