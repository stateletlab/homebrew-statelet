class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-arm64.tar.gz"
      sha256 "17b77bc63da1f2a1328c096f4bb40a764da678f7eedf14ff186e135e3372ee08"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-amd64.tar.gz"
      sha256 "ad9677f2ad4bd058057fa04dfeba591863c84d2bebdd2c8223d0358786a5f90c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-arm64.tar.gz"
      sha256 "d6d1bc43cb2910de08bdd2cf3e0c80136be91a75c850ee4dd1e9af0df89a39a1"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-amd64.tar.gz"
      sha256 "80c70b8f7908715a6d48ca0f1ab0e9340c5ab6eac14cd5b18e8fbd441458de59"
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
