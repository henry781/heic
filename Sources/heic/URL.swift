import Foundation

extension URL {
    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }

    var isFile: Bool {
        (try? resourceValues(forKeys: [.isRegularFileKey]))?.isRegularFile == true
    }
}