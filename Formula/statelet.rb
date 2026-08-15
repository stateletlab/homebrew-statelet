class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-arm64.tar.gz"
      sha256 "fafaef627a3d17ee89cd19564457cc8a074401abbf2032a2e27b9e221bd30c85"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-amd64.tar.gz"
      sha256 "602e7464f9fc3f1daf1d61c4c9e3054df608cfc2e17e16d0b33de359e070257a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-arm64.tar.gz"
      sha256 "5c7dc80bcb06094f4015f86d081527e9a83363ce3ea01c3f4bad44ad7a8d31fe"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-amd64.tar.gz"
      sha256 "f9b54f7991fcadcd7be4347473daae52c4ce3fc154665eb662bb054968fc195e"
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
