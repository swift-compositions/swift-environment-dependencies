public import Environment_Dependencies_Core
public import Foundation

extension EnvVars {
    public func baseUrl() throws(EnvVarsError) -> Foundation.URL {
        guard let urlString = self["BASE_URL"] else {
            throw EnvVarsError.missingVariable("BASE_URL")
        }
        guard let url = Foundation.URL(string: urlString) else {
            throw EnvVarsError.invalidFormat(
                variable: "BASE_URL",
                expectedType: "URL",
                value: urlString
            )
        }
        return url
    }

    public mutating func setBaseUrl(_ url: Foundation.URL) {
        self["BASE_URL"] = url.absoluteString
    }

    public var allowedInsecureHosts: [Swift::String]? {
        get {
            self["ALLOWED_INSECURE_HOSTS"]?.components(separatedBy: ",").map {
                $0.trimmingCharacters(in: .whitespaces)
            }
        }
        set { self["ALLOWED_INSECURE_HOSTS"] = newValue?.joined(separator: ",") }
    }
}
