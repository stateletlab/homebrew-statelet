class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-arm64.tar.gz"
      sha256 "9fa4e863a16618abe0d8b72681b705b71b0f6f541fbb15eae7dbf42e5b0232d5"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-amd64.tar.gz"
      sha256 "a292c1e4872e1c8709bbbb2ef6f9484e705a337716f2d92ed775f1989305352f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-arm64.tar.gz"
      sha256 "06b80e6def2a35e7a2b0aa413c60ac948983934b35f207fbbd58810d7b2128c4"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-amd64.tar.gz"
      sha256 "ea8ce96f04c70004dab2f65e1b95874d7c275cecb19253b810d72c02283f4fd1"
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
