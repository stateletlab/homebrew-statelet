class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.5"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-darwin-arm64.tar.gz"
      sha256 "d6120293cb68536023de2a5aa22c75b370721181e4a5d523d2e2a39bd569112c"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-darwin-amd64.tar.gz"
      sha256 "4cde4942e06e68cf2ccb35ce2b1e45bb74b267634562dbee70e7d0350a6bea64"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-linux-arm64.tar.gz"
      sha256 "0bb972213cbc35b28fe20d18a2df3b068248b2e3c0bbd4ca63bc696370819971"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-linux-amd64.tar.gz"
      sha256 "5fb13c10346abc579ceecd3f59cff413d825df2925bb17b9e9fc1d2e827d658a"
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
