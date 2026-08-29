class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-arm64.tar.gz"
      sha256 "84ced482fc447ca8a544b4505f8c6b9592fc90f22be01ebedb77f671c47cb57c"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-amd64.tar.gz"
      sha256 "0c6e22b571847dc0fb788bb8fa25e4b3e1381e05540c9efc01e366e3c073c2ce"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-arm64.tar.gz"
      sha256 "9deb948d4cc7d2febd07310ccca52923b5f2c92ba013f1e874e3de5ae224c993"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-amd64.tar.gz"
      sha256 "fd0f090188f7483222c04754b8bc80f274367e8d3b841611e7b85ed0e71e559a"
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
