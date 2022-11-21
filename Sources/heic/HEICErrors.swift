import Foundation

enum HEICErrors: Error, LocalizedError, CustomNSError {
    case invalidSourceExtension
    case invalidDestinationExtension
    case invalidMacosVersion
    case heifWriting(message: String)
    case enumerateFiles
    case createDirectory(directory: String, message: String)
    case invalidSourceDirectory
    case invalidDestinationDirectory
    case invalidQuality

    var errorDescription: String? {
        switch self {
        case .invalidSourceExtension:
            return "source file should have extension in .\(HEICConverter.extensions)"
        case .invalidDestinationExtension:
            return "destination file should have extension .\(HEICConverter.heicExtension)"
        case .invalidMacosVersion:
            return "version of Macos should be greater than 10.13.4"
        case .heifWriting(let message):
            return "error while converting image, \(message)"
        case .enumerateFiles:
            return "fail to enumerate files"
        case .createDirectory(let directory, let message):
            return "error while creating directory \(directory), \(message)"
        case .invalidSourceDirectory:
            return "source should be a directory"
        case .invalidDestinationDirectory:
            return "destination should be a directory"
        case .invalidQuality:
            return "quality should be between 1 and 100"
        }
    }

    var errorCode: Int {
        switch self {
        case .invalidSourceExtension:
            return 101
        case .invalidDestinationExtension:
            return 102
        case .invalidMacosVersion:
            return 103
        case .heifWriting:
            return 104
        case .enumerateFiles:
            return 105
        case .createDirectory:
            return 106
        case .invalidSourceDirectory:
            return 107
        case .invalidDestinationDirectory:
            return 108
        case .invalidQuality:
            return 109
        }
    }
}