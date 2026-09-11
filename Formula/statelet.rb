class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-arm64.tar.gz"
      sha256 "a7f29f2cb48aef318284c3f6722ea17b101834dc337044bdb01a691ff5b20ca7"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-amd64.tar.gz"
      sha256 "4202a221d8e6d69f3ebe566dadced8699bb42c86cb37525c9e1f510c90d7b539"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-arm64.tar.gz"
      sha256 "8ac11037762715e62d0b91f025f63ba29f06fb4ae9d689df6fb03eed270769fd"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-amd64.tar.gz"
      sha256 "d4da2fdf2acbb4eeabe98b3dd3a91429f1867eb995a524b328b142c2952002f4"
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
