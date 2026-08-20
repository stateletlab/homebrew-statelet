class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-arm64.tar.gz"
      sha256 "dc79789feeef63da9581d50ee3e2acefa08e45b1dce97aaa4967fc19d38fde9b"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-amd64.tar.gz"
      sha256 "56aff811b3edd0352be8ba1756d1146a3f8e4bf4fa93e33ea4c8d4a2248c693e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-arm64.tar.gz"
      sha256 "85f57d805571825edaed5341c8e3392b3899af26a925b4ccb2fa3cdeb79fbb95"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-amd64.tar.gz"
      sha256 "e71429fd40a9ea98472330d10f8cd15ebecb7a56ed602ce410a0cced967cc658"
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
