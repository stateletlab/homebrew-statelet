class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-darwin-arm64.tar.gz"
      sha256 "7573fef96a4bd76bf4e1b85d12bf68b80795090c42ac5ea98c2d95439062bf1a"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-darwin-amd64.tar.gz"
      sha256 "8120162d8f8f9e8616f0c865e9f4a443899f09f8f43c6e7ba99b56b674e84adc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-linux-arm64.tar.gz"
      sha256 "07eff53d405ff011afbedc7e30d14c7059330b128efae682cb424df3c9c514bd"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.5/statelet-0.1.5-linux-amd64.tar.gz"
      sha256 "f21d6ad66143dfaf4ba4daa44e66425e0cf92490c2308311ed1c247eba25e700"
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
