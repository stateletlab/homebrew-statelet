class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-arm64.tar.gz"
      sha256 "4a329c6ab39f7c16d6f706a6cbf1722745a4b67c6fc9ae33e9cd778c724c9943"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-amd64.tar.gz"
      sha256 "1fed86402389b9c5bd0214cd622c823e9650e83d5b8487d78bfd5802759c564b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-arm64.tar.gz"
      sha256 "bf6b72e4eab94237f632201be56a6cc14f85f6eadbfd45d009eac8f7f9a21b3f"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-amd64.tar.gz"
      sha256 "582bdafb64d36f418f7dd9e9260a2b9f62d0ed228749e6f90971efbed9a78c92"
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
