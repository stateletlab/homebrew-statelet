class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.5"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-darwin-arm64.tar.gz"
      sha256 "3e62f5c571373403e01c576c674dd47dac295d98a71aaa23787bb006c1fb5a70"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-darwin-amd64.tar.gz"
      sha256 "86e26abaa366646ef881e9050525c3a2bebcb7efd8535c8f817b66fa6601d8fb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-linux-arm64.tar.gz"
      sha256 "0323bea62a5a93ccda28e40ae3cfb91caed26b6bd2b74f92138c7f1e10a10ed6"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-linux-amd64.tar.gz"
      sha256 "68ceae222a137ed0f136b5d83bcfa31550df3208a53cc857612c32b09dc5a4d8"
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
