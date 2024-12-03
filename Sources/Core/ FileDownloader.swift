//
//   FileDownloader.swift
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

                print("Download completed: \(destinationPath)")
            } catch {
                print("Failed to download \(url.absoluteString): \(error.localizedDescription)")
            }
        }

        return downloadedFiles
    }

    private static func downloadFile(from url: URL) async throws -> String {
        let (tempURL, response) = try await URLSession.shared.download(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let fileName = url.lastPathComponent.isEmpty ? "downloaded.md" : url.lastPathComponent
        let destinationPath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName).path

        let fileSize = httpResponse.expectedContentLength
        print("File size: \(fileSize / 1024) KB")

        try FileManager.default.moveItem(atPath: tempURL.path, toPath: destinationPath)

        return destinationPath
    }
}
