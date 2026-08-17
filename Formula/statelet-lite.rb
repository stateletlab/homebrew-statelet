class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-darwin-arm64.tar.gz"
      sha256 "0e8221f32a0007d255fb810ff5d2708fb7f42ba5455f8170c3ab9b65d29cb295"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-darwin-amd64.tar.gz"
      sha256 "f98a2c14d0df7efc600fddbbaf680f43dd95f8c1a92bb6eda03488ca27ca2042"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-linux-arm64.tar.gz"
      sha256 "3464f55e1d5db3869236b70e570ae081a9cef26e215effe25b61b13bc60deca3"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-linux-amd64.tar.gz"
      sha256 "fc5f11c00dc078f6600556bb8d0f3e9af2c7263204179333dcd2427c95a20891"
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
