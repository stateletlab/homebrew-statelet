class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-arm64.tar.gz"
      sha256 "07e75562cf741e1121f1989071ffa414b084b61c5b95a7db0711420a019b86fa"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-amd64.tar.gz"
      sha256 "47b1067e563392b2dc39fcff40d46bc03c3c6a5cb047769c6fd701a3d4b96601"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-arm64.tar.gz"
      sha256 "d1a9c4e0dd283fa7c802ac4e1d08ca382dd78aa31d72e3dd17a8396ab351cdfc"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-amd64.tar.gz"
      sha256 "9f4457bc96988b9f938f911ac7d2f9d3c144da4fd860a0dff94dfdfd45026919"
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
