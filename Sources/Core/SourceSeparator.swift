//
//  SourceSeparator.swift
//  MarkdownStitcher
//
//  Created by Christopher Jr Riley on 2024-12-03.
//

import Foundation

public struct SourceSeparator {
    public static func separate(sources: [String]) -> (localFiles: [String], urls: [URL]) {
        var localFiles: [String] = []
        var urls: [URL] = []

        for source in sources {
            if let url = URL(string: source), url.scheme != nil {
                urls.append(url)
            } else {
                localFiles.append(source)
            }
        }

        return (localFiles, urls)
    }
}
