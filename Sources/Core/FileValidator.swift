//
//  FileValidator.swift
//  MarkdownStitcher
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

public struct FileValidator {
    public static func validate(filePaths: [String]) -> (validFiles: [String], invalidFiles: [String]) {
        var validFiles: [String] = []
        var invalidFiles: [String] = []

        for file in filePaths {
            if FileManager.default.fileExists(atPath: file) {
                validFiles.append(file)
            } else {
                invalidFiles.append(file)
            }
        }

        return (validFiles, invalidFiles)
    }
}
