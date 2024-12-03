//
//  MarkdownCombiner.swift
//  MarkdownStitcher
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

public struct MarkdownCombiner {
    public static func combine(filePaths: [String]) async -> String {
        var combinedContent = ""

        for filePath in filePaths {
            do {
                let content = try await readFileContent(from: filePath)
                let delimiter = createDelimiter(for: filePath)
                combinedContent.append("\(delimiter)\n\(content)\n")
            } catch {
                print("Failed to read file: \(filePath). Error: \(error.localizedDescription)")
            }
        }

        return combinedContent
    }

    private static func readFileContent(from filePath: String) async throws -> String {
        return try String(contentsOfFile: filePath)
    }

    private static func createDelimiter(for filePath: String) -> String {
        let fileName = (filePath as NSString).lastPathComponent
        return """
        \n\n
        -------- START OF FILE: \(fileName) --------
        \n\n
        """
    }
}
