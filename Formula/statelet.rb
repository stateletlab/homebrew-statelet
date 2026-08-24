class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-arm64.tar.gz"
      sha256 "9dce8616c9bb3b75d41992e170123debdbb7c707e8f0ea03d792101e623fdd7b"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-amd64.tar.gz"
      sha256 "9c642216c97bdb5935f023bdd61cd34b18f8eacfad1c860899ff0438a70ec02c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-arm64.tar.gz"
      sha256 "6cd04b98cb2d3693e53f7dd429d9ea16c205728c613695deaed1632db1dabda0"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-amd64.tar.gz"
      sha256 "85ff41edde98c4f344596fe675e0ee2d9d6324e49e247b7b25065abe4d8bae72"
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
