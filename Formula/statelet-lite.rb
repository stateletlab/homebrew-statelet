class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.7"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-arm64.tar.gz"
      sha256 "b61d697e594660169f62051c089fcb5c6bbef4d06e9c10c1b665b675cfdf4c22"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-darwin-amd64.tar.gz"
      sha256 "e9ee3356f86db0624f2ada68fee3759c0662cc7418b72e77fa007395b9d5fe2e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-arm64.tar.gz"
      sha256 "7c98ffa0b54811b9c4666daf2405dec2533c1e15a36f9b47c6a2e610a1c85f53"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.7/statelet-lite-0.1.7-linux-amd64.tar.gz"
      sha256 "7385a2d015db380cc3785d8a7da137e4f4b297124b894921d2cd975da6fded6c"
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
