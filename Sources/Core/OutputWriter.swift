//
//  OutputWriter.swift
//  MarkdownStitcher
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

public struct OutputWriter {
    public static func write(content: String, to outputPath: String) async throws -> String {
        let directory = (outputPath as NSString).deletingLastPathComponent
        guard FileManager.default.fileExists(atPath: directory) else {
            throw NSError(
                domain: "com.markdownstitcher",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Directory does not exist: \(directory)"]
            )
        }

        // Write the content to the file
        try content.write(toFile: outputPath, atomically: true, encoding: .utf8)
        return outputPath
    }
}
