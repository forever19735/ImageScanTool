import XCTest
@testable import ImageScanCore

final class ImageScanToolTests: XCTestCase {
    func test_scanFile_detectsDynamicImageUsage() {
        let scanner = Scanner()
        let testSource = """
        import UIKit

        let image1 = UIImage(named: "icon_home") // static, should be skipped
        let image2 = UIImage(named: imageName)    // dynamic, should be included
        let image3 = UIImage(named: spec.icon)    // dynamic, should be included
        let image4 = UIImage(named: "icon_\\(state)") // interpolated, should be included
        """

        // 使用臨時目錄避免污染工作區
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("ImageScanTest_\(UUID().uuidString)")
        
        do {
            // 創建臨時目錄
            try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
            
            // 創建測試檔案
            let testFile = tempDir.appendingPathComponent("temp_test.swift")
            try testSource.write(to: testFile, atomically: true, encoding: .utf8)

            // 執行掃描
            let whitelist = scanner.scanDirectory(at: tempDir.path)

            // 驗證結果
            XCTAssertTrue(
                whitelist.contains { $0.contains("imageName") },
                "Should detect variable-based usage. Found: \(whitelist)"
            )
            XCTAssertTrue(
                whitelist.contains { $0.contains("spec.icon") },
                "Should detect property-based usage. Found: \(whitelist)"
            )
            XCTAssertTrue(
                whitelist.contains { $0.contains("\\(state)") },
                "Should detect interpolated usage. Found: \(whitelist)"
            )
            XCTAssertFalse(
                whitelist.contains { $0.contains("icon_home") },
                "Should skip static string usage. Found: \(whitelist)"
            )
            
            // 驗證檢測到的動態用法數量
            XCTAssertEqual(
                whitelist.count,
                3,
                "Should detect exactly 3 dynamic usages, but found \(whitelist.count): \(whitelist)"
            )

        } catch {
            XCTFail("Test setup failed: \(error)")
        }
        
        // 清理臨時檔案
        try? FileManager.default.removeItem(at: tempDir)
    }
}
