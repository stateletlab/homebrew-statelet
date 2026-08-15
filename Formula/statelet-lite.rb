class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-darwin-arm64.tar.gz"
      sha256 "a462da53553e1e34c5a2e6489642f85afeb1cb2600f4118c81d8a3cdb2af4f13"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-darwin-amd64.tar.gz"
      sha256 "d2e4a980d9ac88f2d7231b9ddc487a4d2449f6d9519fe36197d541af7237a9d3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-linux-arm64.tar.gz"
      sha256 "baa7ddf2e652e869d04914057e991fd1a18be9dd5a871c7d74b701612e48ddc4"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-linux-amd64.tar.gz"
      sha256 "4341514bbfb49127fad89bf8ff8a39412dfcb7f30c19f03ffcd491ade83830f7"
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
