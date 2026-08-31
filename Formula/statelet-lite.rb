class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-arm64.tar.gz"
      sha256 "252d219630ccce378cd2901d4ec22f9f616540f35da193d361f53e3481f28069"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-amd64.tar.gz"
      sha256 "03ec0d6e109381ac9fceeb001863e3a1fdee26c20579f1616b31ab72172f7867"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-arm64.tar.gz"
      sha256 "090adcfc6dbd6b28871faab92e429065208460e75ebd3f7d90e98a82ddb6e520"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-amd64.tar.gz"
      sha256 "d9db84fe5ccc6314d5a8a76a7ce4559932768253210d1477b49a9db059b6f2a2"
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
