import Environment
public import Environment_Dependencies_Core
public import Foundation

extension EnvVars {

    public static func live(localEnvFile: Foundation.URL?) throws(EnvVarsError) -> EnvVars {
        var dictionary = Environment.read.all()
        if let localEnvFile {
            let data: Foundation.Data?
            do {
                data = try Foundation.Data(contentsOf: localEnvFile)
            } catch {
                data = nil
            }
            if let data {
                let text = Swift::String(decoding: data, as: Swift::UTF8.self)
                let fileValues: [Swift::String: Swift::String]?
                do throws(Environment.Dotenv.Error) {
                    fileValues = try Environment.Dotenv(parsing: text).values
                } catch {
                    fileValues = nil
                }
                if let fileValues {
                    for (key, value) in fileValues { dictionary[key] = value }
                }
            }
        }
        return try EnvVars(dictionary: dictionary, requiredKeys: [])
    }

    public static func live(
        environmentConfiguration configuration: EnvironmentConfiguration
    ) throws(EnvVarsError) -> EnvVars {
        var dictionary = Environment.read.all()
        if let fileValues = configuration.load() {
            for (key, value) in fileValues { dictionary[key] = value }
        }
        return try EnvVars(dictionary: dictionary, requiredKeys: [])
    }
}
