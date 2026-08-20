class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-darwin-arm64.tar.gz"
      sha256 "c7bdccfb330991d3cdce5b009496a60a6e57a9c18ffb516c3319233e31d89f8e"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-darwin-amd64.tar.gz"
      sha256 "ec9cc1524ba41cfef8b4048bbac490788c008938aeac3b4c80a26fdc4d2be8e2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-linux-arm64.tar.gz"
      sha256 "9ca1a8eac6a0116cd9973abd72a2196580afa501aad440387c606328b2f44bbd"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-linux-amd64.tar.gz"
      sha256 "658e4bf3489efb82a42fc541c4be5e7977e4690c2644a6a59cbb1e049fc05ffd"
    end
  end

  def install
    bin.install "statelet-metadata"
    bin.install "statelet-datanode"
    bin.install "statelet-gateway"
    bin.install "statelet-cli"
    bin.install "statelet-admin"
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
