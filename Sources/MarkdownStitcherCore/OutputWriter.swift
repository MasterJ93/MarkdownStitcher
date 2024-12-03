//
//  OutputWriter.swift
//  MarkdownStitcher
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

public struct OutputWriter {
    public static func write(content: String, fileName: String) -> String {
        let outputFilePath = FileManager.default.currentDirectoryPath + "/" + fileName

        do {
            try content.write(toFile: outputFilePath, atomically: true, encoding: .utf8)
            return outputFilePath
        } catch {
            print("Failed to write output file: \(error)")
            exit(1)
        }
    }
}
