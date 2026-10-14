import Environment
public import Environment_Dependencies_Core
public import Foundation

extension EnvVars {

    public enum EnvironmentConfiguration: Sendable {

        case projectRoot(Foundation.URL, environment: Swift::String?)

        case localEnvFile(Foundation.URL)
    }
}

extension EnvVars.EnvironmentConfiguration {

    func load() -> [Swift::String: Swift::String]? {
        let url: Foundation.URL?
        switch self {
        case .localEnvFile(let file):
            url = file

        case .projectRoot(let root, let environment):
            let candidates = environment.map { [".env.\($0)", ".env"] } ?? [".env"]
            url =
                candidates
                .map { root.appendingPathComponent($0) }
                .first { FileManager.default.fileExists(atPath: $0.path) }
        }
        guard let url else { return nil }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            return nil
        }
        let text = Swift::String(decoding: data, as: Swift::UTF8.self)
        do throws(Environment.Dotenv.Error) {
            return try Environment.Dotenv(parsing: text).values
        } catch {
            return nil
        }
    }
}
