class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-darwin-arm64.tar.gz"
      sha256 "72acc1eecbef8861080e6df6572d189182ba1a60ca9c1b864cdb0896518f61d8"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-darwin-amd64.tar.gz"
      sha256 "1007c36ade90a24e5d148f3a56166b22cc88fa6e74cd2a02d770de264e9f994f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-linux-arm64.tar.gz"
      sha256 "38b9be83bdf2bb113a1c3d4f41c5b8a89548c52b7f75f0239d730bf9a1afb584"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-linux-amd64.tar.gz"
      sha256 "93c354d0a20581e39c6e405c5458b6c1e7536052cef268a49e0172cad9ec3d0b"
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
