class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-arm64.tar.gz"
      sha256 "589a412520a87ae3cdd93afdb11592f7cde5a796958fa61ca0e0cf77709b99be"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-amd64.tar.gz"
      sha256 "a16612f40c682ed5e92428c2984dbac604effe61b9d4b24a1282e858dff8c79f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-arm64.tar.gz"
      sha256 "93623d5370799fa2adc4ab6f2d86c65a45228babf4e187a7ccd4ab640709520d"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-amd64.tar.gz"
      sha256 "6bc887410f6bb5360f0686a95685798f5e05702be5cd763f3416658805c03217"
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
