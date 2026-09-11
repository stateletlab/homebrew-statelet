class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-arm64.tar.gz"
      sha256 "8c73d905d44edfeaaff1ba8fdf65c51efa37cf1ca1437bccc25be5b76f787ea2"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-amd64.tar.gz"
      sha256 "ad0f2dcc4b3671fd867597f1340a9f8bddf389eaafc84e575cd2ea31ab824d75"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-arm64.tar.gz"
      sha256 "7b43561ab4aadd382e510e39cfcbdf4f9af6934e57a47feccff1d76b5c7e95e7"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-amd64.tar.gz"
      sha256 "072efd1869eba3d99e15884f6f0736ae9b15670ae95b5e2f2ad5eac1a3689ff1"
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
