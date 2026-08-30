class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-arm64.tar.gz"
      sha256 "cf48caa8b324aec4c2de6cfbaccbc3578f71baff8a81921e1d2eda66bd3b39a3"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-amd64.tar.gz"
      sha256 "9d82287a00101e7998f5d9d8898e51faaca717392f59e56ed4d858b93d0bd6f3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-arm64.tar.gz"
      sha256 "cde4248162a06a42c62993440339ddee16bb6ef714b9c31e5c8cba7f14be0032"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-amd64.tar.gz"
      sha256 "cc876d118087e5a64a2cc545d270080657b8ff5bac765bbcbf84ca6be76a04da"
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
