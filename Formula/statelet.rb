class Statelet < Formula
  desc "Distributed key-value storage engine with LSM-tree, Raft, and vector index"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-arm64.tar.gz"
      sha256 "cdd8ec3cc994bb480b93ca4854c49a69fc16156be7201a8a50718a9d3fa546cc"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-darwin-amd64.tar.gz"
      sha256 "419104c6d7ca1c3fde8fc05fc5a518753cc0d393c4306bd691cdbbbb707ad18b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-arm64.tar.gz"
      sha256 "3bb0cc76e51bb0dfb65b374c3de7f3d19fa86f45fc18b0f04a706378de8497e6"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/v0.1.7/statelet-0.1.7-linux-amd64.tar.gz"
      sha256 "de320a01541e0dc7ccf680e0552489063d17f46e70235c1c14714a97835f0808"
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
