class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-darwin-arm64.tar.gz"
      sha256 "1687b54b4c507cfeed8b756e2eda296c471636678a34b39ceec93a53591117b6"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-darwin-amd64.tar.gz"
      sha256 "14a8fd6d25b90cfdd98de17ba6940b5d2e714a60f75f689ef806a6ed41c62f25"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-linux-arm64.tar.gz"
      sha256 "6afbd70e0679156d8c2c97d2d95dfaf7a74f03667e3aa5e19b2fba697487dba2"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-linux-amd64.tar.gz"
      sha256 "ef6eec8cb5b5d15c4c3d4376bce1c751b585223a8ca0e79e5d0d6e54af083d93"
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
