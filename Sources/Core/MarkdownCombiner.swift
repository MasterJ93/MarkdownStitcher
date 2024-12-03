//
//  MarkdownCombiner.swift
//  MarkdownStitcher
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

public struct MarkdownCombiner {
    public static func combine(filePaths: [String]) -> String {
        var combinedContent = ""

        for (_, file) in filePaths.enumerated() {
            if let content = try? String(contentsOfFile: file) {
                // Add a delimiter before appending content
                let delimiter = createDelimiter(for: file)
                combinedContent.append(delimiter)
                combinedContent.append("\n\(content)\n")
            } else {
                print("Failed to read file: \(file)")
            }
        }

        return combinedContent
    }

    private static func createDelimiter(for filePath: String) -> String {
        let fileName = (filePath as NSString).lastPathComponent
        let delimiter = """
        \n\n
        -------- START OF FILE: \(fileName) --------
        \n\n
        """
        return delimiter
    }
}
