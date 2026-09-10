class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-arm64.tar.gz"
      sha256 "d3342c3f6ff62d43d830cbced0ba9eed0edb3dbe5fe5f984cbbd19dbb967134f"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-amd64.tar.gz"
      sha256 "79819d735af26d70098e593584b3241926155c25ce8a7bdd7a358020dc6c5a85"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-arm64.tar.gz"
      sha256 "fd9bb2b72750f4b7e7adbed82202010bdcb0756a8f08fd87fd9384543b3aa1a3"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-amd64.tar.gz"
      sha256 "717053db565678ec496eb0027beb11d28899fd722a2c277f8f10c10a73eede72"
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
