class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-arm64.tar.gz"
      sha256 "d36293d212137e56aa6fcb6b65ac958cec575e5e3e279afc5af88af74af83d63"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-amd64.tar.gz"
      sha256 "1c2b166ef2c299a01f2fa958441e1f435d91da1877da36544d288265e27aaf56"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-arm64.tar.gz"
      sha256 "1239cdf6eee5976cc39aecaf5fdba3d64e903bc7c4676fa11b3235a5fc547a03"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-amd64.tar.gz"
      sha256 "4c79a52a396653cede7fe0aabe522e63baba7c690138220227fbaba26be797ab"
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
