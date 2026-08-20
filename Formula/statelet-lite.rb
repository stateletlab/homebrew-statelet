class StateletLite < Formula
  desc "Single-node Statelet database in one binary"
  homepage "https://github.com/stateletlab/statelet"
  version "0.1.4"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-darwin-arm64.tar.gz"
      sha256 "1134f4482f54e925e7578e2299c46508eae04893a51e4e9724c55a011566cc83"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-darwin-amd64.tar.gz"
      sha256 "a4449ab8fbd1e6c1cfa9aa7fd9abb6ac368f7eff5581cf9e7a3aad137a698ae0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-linux-arm64.tar.gz"
      sha256 "86dc17cf9b82d05a449f798771f277d64c73da87579ccba16dae031da16d394b"
    else
      url "https://github.com/stateletlab/statelet-longmemeval/releases/download/lite-v0.1.4/statelet-lite-0.1.4-linux-amd64.tar.gz"
      sha256 "1355dc43399bc06053f642b6706e5147737ef94188f48782a6acdac53d32b052"
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
