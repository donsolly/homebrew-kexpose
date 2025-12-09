# This file is automatically updated by the release workflow
# DO NOT manually edit version, url, or sha256 fields - they will be overwritten

class Kexpose < Formula
  desc "Cross-platform Kubernetes port-forward manager with TUI"
  homepage "https://github.com/donsolly/homebrew-kexpose"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-darwin-arm64.tar.gz"
      sha256 "a5a7b1ee540159cb2d8adef4013f9e2022fff87f8e7790cf22dbc0d1d6bd6068"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-darwin-amd64.tar.gz"
      sha256 "eb6294ac231d07f661df221280c4bf016af54c142585000df829abf912fc9434"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-arm64.tar.gz"
      sha256 "b566d84543d40e25b15c248f32422b2769b2e62c17dae3e2759f4cea94dca3e1"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-amd64.tar.gz"
      sha256 "b566d84543d40e25b15c248f32422b2769b2e62c17dae3e2759f4cea94dca3e1"
    end
  end

  depends_on "lsof" if OS.linux?

  def install
    bin.install "kexpose"
  end

  def caveats
    <<~EOS
      kexpose requires:
      - Access to a Kubernetes cluster with valid kubeconfig
      - lsof for port scanning
        macOS: pre-installed
        Linux: install with your package manager (apt install lsof, yum install lsof, etc.)

      Run 'kexpose doctor' to check your system configuration.

      Configuration: ~/.kexpose/
      Logs: ~/.kexpose/logs/kexpose.log
    EOS
  end

  test do
    # Test version command
    assert_match version.to_s, shell_output("#{bin}/kexpose --version")

    # Test doctor command (will fail without kubeconfig, but validates binary works)
    system "#{bin}/kexpose", "doctor"
  end
end
