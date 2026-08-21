class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-darwin-arm64.tar.gz"
      sha256 "59c94a75e053aa195d574724c6e2c74226a12859b385ad634603f8180227f796"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-darwin-amd64.tar.gz"
      sha256 "1850ced2314271c53ef418fc630e7d01cc00f74ffadb99fdd9881db8f845f5cd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-linux-arm64.tar.gz"
      sha256 "c045692a58f2c3529ba44312f29c7e09e94d99748a3e6beb6b378c5063118137"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-linux-amd64.tar.gz"
      sha256 "17b0f5e765db79eef142c34700452f9d8f96d6b10ba5f9f5733c88a784a9cc6f"
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
