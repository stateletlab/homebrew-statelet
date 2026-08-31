class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.6"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-arm64.tar.gz"
      sha256 "ddb819c8a51b37ade1a4655d0d77e0761e054727e8e05b19c1d61bd5e81514ae"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-darwin-amd64.tar.gz"
      sha256 "3a761075dbfc3557a4d455c7a8da81415e0a4d535ed9a2bbe7dc9ebc99ab472e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-arm64.tar.gz"
      sha256 "68b4d7c77776705ea870f5d5dd0754e8952b6c805545b60c87cc5d90892b172c"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.6/statelet-lite-0.1.6-linux-amd64.tar.gz"
      sha256 "5c7b2de74c2660ae021b326f9596fb4ecc1cebbe2d949eed75afd8c9507c924a"
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
