// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

let arguments = CommandLine.arguments

if arguments.count < 2 {
    print("Usage: markdownstitcher <file1.md> <file2.md> ...")
    exit(1)
}

let markdownFiles = Array(arguments.dropFirst())

// Validate files
let (validFiles, invalidFiles) = FileValidator.validate(filePaths: markdownFiles)

if !invalidFiles.isEmpty {
    print("The following files do not exist or cannot be accessed:")
    invalidFiles.forEach { print("- \($0)") }
    exit(1)
}

print("Valid Markdown files:")
validFiles.forEach { print("- \($0)") }

// Combine content
let combinedContent = MarkdownCombiner.combine(filePaths: validFiles)

// Write output
let outputFilePath = OutputWriter.write(content: combinedContent, fileName: "stitched_output.md")
print("Output written to \(outputFilePath)")
