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

    let downloadedFiles = await FileDownloader.download(urls: urls)

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

    func runGuidedMode() async {
        var filePaths: [String] = []

        while true {
            print("""
                Type the file path or URL of the Markdown file(s) and press Return.
                (To stitch together the Markdown files, type "--output <output_path>".
                To view the files you've added so far, type "--view".)
                """)

            if let input = readLine(), !input.isEmpty {
                if input.starts(with: "--output ") {
                    let outputPath = String(input.dropFirst("--output ".count))
                    print("Stitching Markdown files...")

                    let (localFiles, urls) = SourceSeparator.separate(sources: filePaths)
                    let downloadedFiles = await FileDownloader.download(urls: urls)
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
                    print("Files added so far:")
                    filePaths.forEach { print("- \($0)") }
                } else {
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
