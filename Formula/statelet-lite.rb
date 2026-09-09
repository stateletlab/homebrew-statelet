class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-arm64.tar.gz"
      sha256 "6f12b7c8c97d29cb81f1bd5cf64c98281964a998ba487fca176764de6231a915"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-amd64.tar.gz"
      sha256 "ac7fdf7fab2a138eeb915145f318c5df4fbf4362af6ea6db56e389888c7582c6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-arm64.tar.gz"
      sha256 "4f39be4930427920369a87444cda5d1c5e848d7b7d6f03846afb886b3d01e7bd"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-amd64.tar.gz"
      sha256 "be495f02247c6dc5612ef138d45d310ae1ac804637243f5dbda396f7bceb0819"
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
