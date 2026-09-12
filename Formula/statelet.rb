class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-arm64.tar.gz"
      sha256 "5b8550df52527f4a6cd5ab19accab52ddfa52db764df0968f9c711dd5ad00896"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-amd64.tar.gz"
      sha256 "522ab1ca7c668d6b031a317aac7add23524cb3492ee9883ac6b71ad32b788cf1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-arm64.tar.gz"
      sha256 "b4f91195fcd6180d74fbbeea2471253d36feb38b0bb478ac017c50c63e691684"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-amd64.tar.gz"
      sha256 "307cb16b4c9786852378eb074dade3d71d0a74cea4a681c9921285bfb2b51ebd"
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
