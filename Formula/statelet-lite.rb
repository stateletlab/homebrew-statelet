class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-arm64.tar.gz"
      sha256 "e2f2aab45c9f6b0db7426f1fa041cdd3d2544e24ea50672101b68bf8e5413ae7"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-amd64.tar.gz"
      sha256 "5e1f58d8f50d821def123c7babf7b9444f0880ba2b103a31ca8e0f5d3a7a3729"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-arm64.tar.gz"
      sha256 "062749dc491ede1ef554a01a48977f8d26778b3b84d477ec844461490b393267"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-amd64.tar.gz"
      sha256 "93e597161c129ca098d4a44df357a7096a085661be459d4c18c6d8cea188bb4c"
    end
  end

  conflicts_with "statelet",
    because: "both install the admin UI at share/statelet/ui and bind the same default ports"

  def install
    bin.install "statelet-lite"
    # statelet-lite resolves the admin UI as ../share/statelet/ui
    # from its own location — deliberately not pkgshare, which would
    # be share/statelet-lite and never probed.
    (share/"statelet/ui").install Dir["ui/*"]
  end

  def post_install
    (var/"statelet-lite").mkpath
    (var/"log/statelet-lite").mkpath
  end

  service do
    run [opt_bin/"statelet-lite", var/"statelet-lite"]
    keep_alive true
    working_dir var/"statelet-lite"
    log_path var/"log/statelet-lite/lite.log"
    error_log_path var/"log/statelet-lite/lite.log"
  end

  test do
    # No --version surface: the only positional argument is the data
    # directory, so probing flags would start a server.
    assert_predicate bin/"statelet-lite", :executable?
  end
end
