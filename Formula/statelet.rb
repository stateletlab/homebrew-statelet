class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.3/statelet-0.1.3-darwin-arm64.tar.gz"
      sha256 "7ac6b9211978c34482de29311ff2db9917f539dfc94707ec0a8e1882e7065101"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.3/statelet-0.1.3-darwin-amd64.tar.gz"
      sha256 "b18bca2ad2a142205bd55e6ff3a67eb6d2396af114f25740e2ba4f80e92a52eb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.3/statelet-0.1.3-linux-arm64.tar.gz"
      sha256 "62f08c7ad5cefb786bce7416c698c0c1947421f5e71a7f0fba99d8987904b6c8"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.3/statelet-0.1.3-linux-amd64.tar.gz"
      sha256 "b96dd235515aa388733f0be6ac2c17d851391038fabfc9e0d2e5b5e0ee0392e8"
    end
  end

  def install
    bin.install "statelet-metadata"
    bin.install "statelet-datanode"
    bin.install "statelet-gateway"
    bin.install "statelet-cli"
    bin.install "statelet-cluster"
    # The gateway resolves the admin UI as ../share/statelet/ui from
    # its own location, so this is the path it will look in.
    (pkgshare/"ui").install Dir["ui/*"]
  end

  def post_install
    (var/"statelet/data/node1").mkpath
    (var/"statelet/metadata").mkpath
    (var/"log/statelet").mkpath
  end

  service do
    run [opt_bin/"statelet-cluster", "start"]
    keep_alive true
    working_dir var/"statelet"
    log_path var/"log/statelet/cluster.log"
    error_log_path var/"log/statelet/cluster.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/statelet-cli --version 2>&1", 2)
  end
end
