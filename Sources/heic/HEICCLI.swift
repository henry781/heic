import ArgumentParser
import Foundation

@main
struct HEICCLI: ParsableCommand {

    static var configuration = CommandConfiguration(
            commandName: "heic",
            abstract: "A utility to convert images to heic.",
            version: "1.0.0")

    @Option(name: .shortAndLong, help: "Quality between 1 and 100 (lossless)")
    var quality: Int? = nil

    @Argument(help: "Source file or directory")
    var source: String

    @Argument(help: "Destination file or directory")
    var destination: String

    mutating func run() throws {

        let sourceUrl = URL(fileURLWithPath: source)
        let destinationUrl = URL(fileURLWithPath: destination)

        if (sourceUrl.isDirectory) {
            try HEICConverter.shared.writeHeic(
                    sourceDirectoryUrl: sourceUrl,
                    destinationDirectoryUrl: destinationUrl,
                    quality: quality)

        } else {
            try HEICConverter.shared.writeHeic(
                    sourceUrl: sourceUrl,
                    destinationUrl: destinationUrl,
                    quality: quality)
        }
    }
}
