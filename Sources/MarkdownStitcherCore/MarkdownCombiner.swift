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

        for file in filePaths {
            if let content = try? String(contentsOfFile: file) {
                combinedContent.append("\n\(content)")
            } else {
                print("Failed to read file: \(file)")
            }
        }

        return combinedContent
    }
}
