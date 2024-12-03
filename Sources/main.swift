// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// Download files from URLs
if #available(macOS 12.0, *) {
    // Check if the user provided arguments
    let arguments = CommandLine.arguments

    // Handle --help or --h
    if arguments.contains("--help") || arguments.contains("--h") {
        print("""
            Usage: markdownstitcher <source1> <source2> ... --output <output_path>
            Example: markdownstitcher file1.md file2.md https://example.com/file.md --output /path/to/output.md
            
            Alternatively, run `markdownstitcher` without arguments for guided mode.
            """)
        exit(0)
    }

    if arguments.count < 2 {
        print("""
            Usage: markdownstitcher <source1> <source2> ... --output <output_path>
            Example: markdownstitcher file1.md file2.md https://example.com/file.md --output /path/to/output.md
            """)
        await runGuidedMode()
        exit(0)
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

    // Collect sources (local files and URLs)
    let sources = Array(arguments[1..<(outputFlagIndex ?? arguments.count)])

    if sources.isEmpty {
        print("Error: No sources provided.")
        exit(1)
    }

    // Separate local files and URLs
    let (localFiles, urls) = SourceSeparator.separate(sources: sources)

    // Download files and defer cleanup
    let downloadedFiles = await FileDownloader.download(urls: urls)

    defer {
        for file in downloadedFiles {
            let tempDirectory = FileManager.default.temporaryDirectory.path
            if file.starts(with: tempDirectory) {
                do {
                    try FileManager.default.removeItem(atPath: file)
                    print("Deleted temporary file: \(file)")
                } catch {
                    print("Failed to delete temporary file: \(file), error: \(error)")
                }
            }
        }
    }

    // Combine local files and successfully downloaded files
    let validFiles = localFiles + downloadedFiles

    if validFiles.isEmpty {
        print("Error: No valid files to process.")
        exit(1)
    }

    print("Valid files:")
    validFiles.forEach { print("- \($0)") }

    // Combine content
    let combinedContent = await MarkdownCombiner.combine(filePaths: validFiles)

    // Use default output path if none is specified
    let finalOutputPath = outputPath ?? FileManager.default.currentDirectoryPath + "/stitched_output.md"

    // Write output
    let resultPath = try await OutputWriter.write(content: combinedContent, to: finalOutputPath)
    print("Output written to \(resultPath)")

    // Guided mode function
    func runGuidedMode() async {
        var filePaths: [String] = []

        while true {
            print("""
        Type the file path or URL of the Markdown file(s) and press Return.
        Commands:
        - "--output <output_path>": Stitch the files and save the output.
        - "--view": View the files you've added so far.
        - "--clear": Clear all added files.
        - "--help": Show this help message.
        - "quit": Exit the program.
        
        """)

            if let input = readLine(), !input.isEmpty {
                if input.starts(with: "--output ") {
                    let outputPath = String(input.dropFirst("--output ".count))
                    print("Stitching Markdown files...")

                    let (localFiles, urls) = SourceSeparator.separate(sources: filePaths)
                    let downloadedFiles = await FileDownloader.download(urls: urls)

                    defer {
                        for file in downloadedFiles {
                            let tempDirectory = FileManager.default.temporaryDirectory.path
                            if file.starts(with: tempDirectory) {
                                do {
                                    try FileManager.default.removeItem(atPath: file)
                                    print("Deleted temporary file: \(file)")
                                } catch {
                                    print("Failed to delete temporary file: \(file), error: \(error)")
                                }
                            }
                        }
                    }

                    let validFiles = localFiles + downloadedFiles

                    if validFiles.isEmpty {
                        print("Error: No valid files to process.")
                        return
                    }

                    print("Valid files:")
                    validFiles.forEach { print("- \($0)") }

                    let combinedContent = await MarkdownCombiner.combine(filePaths: validFiles)
                    do {
                        let resultPath = try await OutputWriter.write(content: combinedContent, to: outputPath)
                        print("Output written to \(resultPath)")
                    } catch {
                        print("Failed to write output file: \(error.localizedDescription)")
                    }
                    return
                } else if input == "--view" {
                    if filePaths.isEmpty {
                        print("No files have been added yet.\n")
                    } else {
                        print("Files added so far:\n")
                        filePaths.forEach { print("- \($0)") }
                        print("\n")
                    }
                } else if input == "--clear" {
                    filePaths.removeAll()
                    print("Cleared all added files.\n")
                } else if input == "--help" {
                    print("""
                Guided Mode Help:
                - Type the file path or URL of a Markdown file to add it to the list.
                - "--output <output_path>": Stitch the files and save the output.
                - "--view": View the files you've added so far.
                - "--clear": Clear all added files.
                - "--help": Show this help message.
                - "quit": Exit the program.
                
                """)
                } else if input == "quit" {
                    print("Exiting the program.")
                    exit(0)
                } else {
                    // Split input into multiple file paths or URLs
                    filePaths.append(contentsOf: input.split(separator: " ").map { String($0) })
                    print("Files added.")
                }
            }
        }
    }

} else {
    print("This program isn't supported in macOS 11 or earlier.")
    exit(1)
}
