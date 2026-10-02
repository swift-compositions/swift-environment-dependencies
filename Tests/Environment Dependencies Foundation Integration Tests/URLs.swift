import Foundation

enum URLs {
    static func url(_ string: String) -> URL? { URL(string: string) }
    static func file(_ path: String) -> URL { URL(fileURLWithPath: path) }
    static func string(_ url: URL) -> String { url.absoluteString }

    static func envExample() throws -> URL {
        let file = FileManager.default.temporaryDirectory
            .appendingPathComponent("environment-dependencies-\(UUID().uuidString).env")
        try Data("APP_SECRET=\"deadbeefdeadbeefdeadbeefdeadbeef\"\nBASE_URL=\"http://localhost:8080\"\n".utf8)
            .write(to: file)
        return file
    }

    static func remove(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}
