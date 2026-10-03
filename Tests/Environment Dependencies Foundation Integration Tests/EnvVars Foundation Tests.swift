import Dependencies_Test_Support
import Testing

@testable import Environment_Dependencies_Foundation_Integration

extension EnvVars {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension EnvVars.Test.Unit {
    @Test
    func `URL accessors round trip`() throws {
        var envVars = EnvVars(["BASE_URL": "https://example.com"])
        #expect(URLs.string(try envVars.baseUrl()) == "https://example.com")

        envVars.setBaseUrl(try #require(URLs.url("https://swift.org")))
        #expect(envVars["BASE_URL"] == "https://swift.org")
    }

    @Test
    func `allowed insecure hosts preserves CharacterSet whitespace semantics`() {
        var envVars = EnvVars([
            "ALLOWED_INSECURE_HOSTS": "\u{00A0}localhost\u{00A0}, 127.0.0.1\t"
        ])
        #expect(envVars.allowedInsecureHosts == ["localhost", "127.0.0.1"])

        envVars.allowedInsecureHosts = ["newhost.com", "another.com"]
        #expect(envVars["ALLOWED_INSECURE_HOSTS"] == "newhost.com,another.com")
    }
}

extension EnvVars.Test.`Edge Case` {
    @Test
    func `invalid URL throws`() {
        let envVars = EnvVars(["BASE_URL": "http://[::1"])
        #expect(throws: EnvVarsError.self) {
            try envVars.baseUrl()
        }
    }

    @Test
    func `missing host list remains nil`() {
        #expect(EnvVars().allowedInsecureHosts == nil)
    }

    @Test
    func `empty host list value retains one empty component`() {
        #expect(EnvVars(["ALLOWED_INSECURE_HOSTS": ""]).allowedInsecureHosts == [""])
    }
}

extension EnvVars.Test.Integration {
    @Test
    func `dotenv URL overlay wins over process environment`() throws {
        let file = try URLs.envExample()
        defer { URLs.remove(file) }

        let direct = try EnvVars.live(localEnvFile: file)
        let configured = try EnvVars.live(environmentConfiguration: .localEnvFile(file))

        #expect(direct["APP_SECRET"] == "deadbeefdeadbeefdeadbeefdeadbeef")
        #expect(configured["BASE_URL"] == "http://localhost:8080")
    }

    @Test
    func `project root dependency key accepts Foundation URL`() {
        let root = URLs.file("/tmp/project")
        withDependencies {
            $0.projectRoot = root
        } operation: {
            @Dependency(\.projectRoot) var projectRoot
            #expect(projectRoot == root)
        }
    }
}
