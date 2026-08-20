class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.5"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-darwin-arm64.tar.gz"
      sha256 "0b75c0f74b746dd2bb1feab2cd45c3ff9398c5777d3e8ca788a2eae571f5f254"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-darwin-amd64.tar.gz"
      sha256 "5d32ad7b59af320c408edf649b36ddf44697e00bf1570fa33dc0a2d9f40f0751"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-linux-arm64.tar.gz"
      sha256 "445fcb14a37ee14d478ad3ab7e7e3378d39c1a90781a3f08edd6cff1a5c74890"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-linux-amd64.tar.gz"
      sha256 "f23ee8df7ab68e77e8f1ce3330e81030ba80b09f67870b18a8a049dbf118103d"
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
