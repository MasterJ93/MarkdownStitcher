//
//  OutputWriter.swift
//  MarkdownStitcher
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

public struct OutputWriter {
    public static func write(content: String, to outputPath: String) -> String {
        // Validate that the directory for the output file exists
        let directory = (outputPath as NSString).deletingLastPathComponent
        if !FileManager.default.fileExists(atPath: directory) {
            print("Error: The directory for the output path does not exist: \(directory)")
            exit(1)
        }

        // Attempt to write the file
        do {
            try content.write(toFile: outputPath, atomically: true, encoding: .utf8)
            return outputPath
        } catch {
            print("Failed to write output file to \(outputPath): \(error)")
            exit(1)
        }
    }
}
