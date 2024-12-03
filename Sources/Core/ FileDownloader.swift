//
//  FileDownloader.swift
//  MarkdownStitcher
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

@available(macOS 12.0, *)
public struct FileDownloader {
    public static func download(urls: [URL]) async -> [String] {
        var downloadedFiles: [String] = []

        for url in urls {
            do {
                print("Starting download: \(url.absoluteString)")

                let destinationPath = try await downloadFile(from: url)
                downloadedFiles.append(destinationPath)

                print("Download completed: \(destinationPath)\n")
            } catch {
                print("Failed to download \(url.absoluteString): \(error.localizedDescription)\n")
            }
        }

        return downloadedFiles
    }

    private static func downloadFile(from url: URL) async throws -> String {
        let (tempURL, response) = try await URLSession.shared.download(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Generate a unique file name for each download
        let fileName = url.lastPathComponent.isEmpty ? "downloaded.md" : url.lastPathComponent
        let uniqueFileName = UUID().uuidString + "-" + fileName
        let destinationPath = FileManager.default.temporaryDirectory.appendingPathComponent(uniqueFileName).path

        let fileSize = httpResponse.expectedContentLength
        print("File size: \(fileSize / 1024) KB")

        // Move the downloaded file to the unique destination path
        try FileManager.default.moveItem(atPath: tempURL.path, toPath: destinationPath)

        return destinationPath
    }
}
