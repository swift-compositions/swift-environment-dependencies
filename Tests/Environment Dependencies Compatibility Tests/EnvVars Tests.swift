import Environment_Dependencies
import Testing

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
    func `legacy import exposes core and Foundation surfaces`() throws {
        var envVars = EnvVars([
            "BASE_URL": "https://example.com",
            "PORT": "8080",
            "ALLOWED_INSECURE_HOSTS": "localhost, 127.0.0.1",
        ])

        #expect(try envVars.port() == 8080)
        #expect(URLs.string(try envVars.baseUrl()) == "https://example.com")
        #expect(envVars.allowedInsecureHosts == ["localhost", "127.0.0.1"])

        envVars.setBaseUrl(try #require(URLs.url("https://swift.org")))
        #expect(envVars["BASE_URL"] == "https://swift.org")
    }
}

extension EnvVars.Test.`Edge Case` {
    @Test
    func `legacy import preserves optional dotenv call shape`() throws {
        _ = try EnvVars.live(localEnvFile: nil)
    }
}

extension EnvVars.Test.Integration {
    @Test
    func `legacy import preserves process-only live call shape`() throws {
        _ = try EnvVars.live()
    }

    @Test
    func `legacy import preserves project root call shape`() {
        let root = URLs.file("/tmp/project")
        let configuration = EnvVars.EnvironmentConfiguration.projectRoot(
            root,
            environment: "testing"
        )

        withDependencies {
            $0.projectRoot = root
        } operation: {
            @Dependency(\.projectRoot) var projectRoot
            #expect(projectRoot == root)
            _ = configuration
        }
    }
}
