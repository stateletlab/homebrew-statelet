class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-arm64.tar.gz"
      sha256 "306ea89b6c7a3a6582058179a06751a4d546a6ba3cc54f40ea2c32a10bd53db3"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-amd64.tar.gz"
      sha256 "2f70b0cccf58020bce6afef6c16856180276d91d8735e5bc5b70331ab4b2922f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-arm64.tar.gz"
      sha256 "75df85206b4affe4e9d1f8a5a6b0c6f742bc63de6f7e69762a4daad9e30a9417"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-amd64.tar.gz"
      sha256 "c87cb9d855b9848e324ffcdd02b380ccc3e0e5b377a415f9c1747fd597bc873e"
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
