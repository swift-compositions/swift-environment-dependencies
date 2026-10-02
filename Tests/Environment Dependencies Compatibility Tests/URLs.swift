import Foundation

enum URLs {
    static func url(_ string: String) -> URL? { URL(string: string) }
    static func file(_ path: String) -> URL { URL(fileURLWithPath: path) }
    static func string(_ url: URL) -> String { url.absoluteString }
}
