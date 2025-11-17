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
      sha256 "290768ff0fd4968cff410b519aceac728c6d30a6953396f27f17b42471f6f088"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-darwin-amd64.tar.gz"
      sha256 "655dd2136fa85ced1a3f25f97d374b474442171ed4269e31656e7ccd6c28af23"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-arm64.tar.gz"
      sha256 "4392df6135809094f7a4c8868c0a06d3a25eea182a7aa4c3789bfca1a5a7b40e"
    else
      url "https://github.com/donsolly/homebrew-kexpose/releases/download/v0.1.0/kexpose-v0.1.0-linux-amd64.tar.gz"
      sha256 "4392df6135809094f7a4c8868c0a06d3a25eea182a7aa4c3789bfca1a5a7b40e"
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
