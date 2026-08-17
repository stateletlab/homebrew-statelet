class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-arm64.tar.gz"
      sha256 "d7b0f2ba195ed03c4e47d05f1c278c669d5b21ce1ba5d036c4e6f65f1eecb0ac"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-amd64.tar.gz"
      sha256 "66f4adf9e8b1007e767765045e0ea7d63e05edf2c443c130a29d86f7b400a4ee"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-arm64.tar.gz"
      sha256 "8ffe980903244493eabf362043f0e8cd0b4c2c8b858e058b990f78ee549d493b"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-amd64.tar.gz"
      sha256 "ba4afec6a306871f9e9e245811d2dc0ce58c6ad4d42605a7b8bd6b7bccdfcf48"
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
