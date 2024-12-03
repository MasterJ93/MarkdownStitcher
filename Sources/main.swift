// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// Check if the user provided arguments
let arguments = CommandLine.arguments

if arguments.count < 2 {
    print("Usage: markdownstitcher <file1.md> <file2.md> ...")
    exit(1)
}

// Collect Markdown file paths from the arguments
let markdownFiles = Array(arguments.dropFirst())

print("Checking Markdown files...")

var validFiles: [String] = []
var invalidFiles: [String] = []

for file in markdownFiles {
    if FileManager.default.fileExists(atPath: file) {
        validFiles.append(file)
    } else {
        invalidFiles.append(file)
    }
}

if !invalidFiles.isEmpty {
    print("The following files do not exist or cannot be accessed:")
    invalidFiles.forEach { print("- \($0)") }
    exit(1)
}

print("Valid Markdown files:")
validFiles.forEach { print("- \($0)") }

// Combine contents of all valid files
var combinedContent = ""
for file in validFiles {
    if let content = try? String(contentsOfFile: file) {
        combinedContent.append("\n\(content)")
    } else {
        print("Failed to read file: \(file)")
    }
}

// Write combined content to an output file
let outputFileName = "stitched_output.md"
let outputFilePath = FileManager.default.currentDirectoryPath + "/" + outputFileName

do {
    try combinedContent.write(toFile: outputFilePath, atomically: true, encoding: .utf8)
    print("Output written to \(outputFilePath)")
} catch {
    print("Failed to write output file: \(error)")
    exit(1)
}

