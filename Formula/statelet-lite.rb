class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.5"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-darwin-arm64.tar.gz"
      sha256 "40f13e9fe2cdcca93cbf7dec2efac3bd65fc57ff92f9d009498d7e0b4fbd5717"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-darwin-amd64.tar.gz"
      sha256 "cf3146791a02b376fbd19e000d584b0d074337b431b4772be8993e67d3f8b16c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-linux-arm64.tar.gz"
      sha256 "a1d9d99e9ca3640224b2409f7aec2d4e557130b12e64ef24a6fef9e732e41224"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.5/statelet-lite-0.1.5-linux-amd64.tar.gz"
      sha256 "d030d563768f16277b65c105bdfa019637b6ce61aed6e8293f58b310d33122be"
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
