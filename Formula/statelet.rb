class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-arm64.tar.gz"
      sha256 "af07d8472fe5dae3b6c1774d17daa2d0cf85eeea465a285dab3a21ff4ed08f92"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-darwin-amd64.tar.gz"
      sha256 "147bf1cb97ec293bd63d0e216b13205821991170c8eb5a3fe1fa356f7f194499"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-arm64.tar.gz"
      sha256 "c6a688ce35ee6d53f1593efa2ebdc6a9254a4d108b28aa200bd7fca32bd05b5c"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.4/statelet-0.1.4-linux-amd64.tar.gz"
      sha256 "6096d6539af3d6183a6997a70f4d4d11cc7734832a7b4414185feb7089282136"
    end
  end

  def install
    bin.install "statelet-metadata"
    bin.install "statelet-datanode"
    bin.install "statelet-gateway"
    bin.install "statelet-cli"
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
