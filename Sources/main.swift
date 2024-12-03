// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// Check if the user provided arguments
let arguments = CommandLine.arguments

if arguments.count < 2 {
    print("""
    Usage: markdownstitcher <file1.md> <file2.md> ... --output <output_path>
    Example: markdownstitcher file1.md file2.md --output /path/to/output.md
    """)
    exit(1)
}

// Parse arguments
let outputFlagIndex = arguments.firstIndex(of: "--output")
var outputPath: String? = nil

if let index = outputFlagIndex {
    if index + 1 < arguments.count {
        outputPath = arguments[index + 1]
    } else {
        print("Error: No output path specified after '--output'.")
        exit(1)
    }
}

// Collect Markdown file paths
let markdownFiles = Array(arguments[1..<(outputFlagIndex ?? arguments.count)])

if markdownFiles.isEmpty {
    print("Error: No Markdown files provided.")
    exit(1)
}

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

// Use default output path if none is specified
let finalOutputPath = outputPath ?? FileManager.default.currentDirectoryPath + "/stitched_output.md"

// Write output
let resultPath = OutputWriter.write(content: combinedContent, to: finalOutputPath)
print("Output written to \(resultPath)")
