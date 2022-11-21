import Foundation
import CoreImage
import Rainbow

struct HEICConverter {

    static let shared = HEICConverter()

    static let heicExtension = "heic"
    static let extensions = ["jpg", "tiff", "jpeg", "png", "bmp"]
    private static let defaultQuality = 80;

    func writeHeic(sourceUrl: URL, destinationUrl: URL, quality: Int?) throws {

        if !HEICConverter.extensions.contains(sourceUrl.pathExtension.lowercased()) {
            throw HEICErrors.invalidSourceExtension
        }
        if destinationUrl.pathExtension.lowercased() != HEICConverter.heicExtension {
            throw HEICErrors.invalidDestinationExtension
        }
        let q = quality ?? HEICConverter.defaultQuality
        if q < 1 || q > 100 {
            throw HEICErrors.invalidQuality
        }

        let qualityOption = String(format: "%.01f", Float(q) / 100)

        let ciImage = CIImage(contentsOf: sourceUrl)
        let ciContext = CIContext(options: nil)
        let options = NSDictionary(dictionary: [kCGImageDestinationLossyCompressionQuality: qualityOption])

        print("\(sourceUrl.relativePath.blue) ➜ \(destinationUrl.relativePath.green), q=\(qualityOption.yellow)")

        guard #available(macOS 10.13.4, *) else {
            throw HEICErrors.invalidMacosVersion
        }
        do {
            try ciContext.writeHEIFRepresentation(of: ciImage!,
                    to: destinationUrl,
                    format: CIFormat.ARGB8,
                    colorSpace: ciImage!.colorSpace!,
                    options: options as! [CIImageRepresentationOption: Any])
        } catch {
            throw HEICErrors.heifWriting(message: error.localizedDescription)
        }
    }

    func writeHeic(sourceDirectoryUrl: URL, destinationDirectoryUrl: URL, quality: Int? = defaultQuality) throws {

        if !sourceDirectoryUrl.isDirectory {
            throw HEICErrors.invalidSourceDirectory
        }
        if !destinationDirectoryUrl.isDirectory {
            throw HEICErrors.invalidDestinationDirectory
        }

        print("extensions \(HEICConverter.extensions) are used to filter files")

        guard let enumerator = FileManager.default.enumerator(
                at: sourceDirectoryUrl,
                includingPropertiesForKeys: [.isRegularFileKey],
                options: [.skipsHiddenFiles, .skipsPackageDescendants])
        else {
            throw HEICErrors.enumerateFiles
        }

        while let sourceUrl = enumerator.nextObject() as? URL {

            if !sourceUrl.isFile {
                print("\(sourceUrl.relativePath.blue) is not a file, skipping")
                continue
            }

            let pathExtension = sourceUrl.pathExtension.lowercased()
            if !HEICConverter.extensions.contains(where: { pathExtension.hasSuffix($0) }) {
                print("\(sourceUrl.relativePath.blue) is not an image, skipping")
                continue
            }

            let sourcePath = sourceUrl.path
            let start = sourcePath.index(sourcePath.startIndex, offsetBy: sourceDirectoryUrl.path.count + 1)
            let sourceRelativePath = String(sourcePath.suffix(from: start))

            let destinationUrl: URL
            if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                destinationUrl = destinationDirectoryUrl
                        .appending(path: sourceRelativePath)
                        .deletingPathExtension()
                        .appendingPathExtension(HEICConverter.heicExtension)
            } else {
                destinationUrl = destinationDirectoryUrl
                        .appendingPathComponent(sourceRelativePath, isDirectory: false)
                        .deletingPathExtension()
                        .appendingPathExtension(HEICConverter.heicExtension)
            }

            let path = destinationUrl.deletingLastPathComponent().path
            do {
                try FileManager.default.createDirectory(
                        atPath: path,
                        withIntermediateDirectories: true,
                        attributes: nil)
            } catch {
                throw HEICErrors.createDirectory(directory: path, message: error.localizedDescription)
            }

            do {
                try writeHeic(sourceUrl: sourceUrl, destinationUrl: destinationUrl, quality: quality)
            } catch {
                print("fail to convert \(sourceUrl.relativePath), error \(error.localizedDescription), skipping".red)
            }
        }
    }
}


