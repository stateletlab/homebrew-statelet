class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-arm64.tar.gz"
      sha256 "76f7021399f7a3cc27ef99e6eb8749633fd734ad2a7bb623fdac84e192a0880b"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-darwin-amd64.tar.gz"
      sha256 "1e3606a33c174db9b4b2466b5b9541c2b983f371a3a68fd17a9c6e3d58ee4ba0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-arm64.tar.gz"
      sha256 "b815177bfc8bbc1863d4266546905cf1ff52c7038dd9bf794d1b588328fb4e47"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.6/statelet-0.1.6-linux-amd64.tar.gz"
      sha256 "5073958e9ba41e30fa575b79b4fea4e4044f2f13b58ff705bb8c6cbe84930861"
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
