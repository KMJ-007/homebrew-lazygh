class Lazygh < Formula
  desc "A Terminal User Interface (TUI) application for managing multiple GitHub accounts easily"
  homepage "https://kmj-007.github.io/lazygh"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kmj-007/lazygh/releases/download/v0.5.0/lazygh-aarch64-apple-darwin.tar.gz"
      sha256 "c49834ef8a22a63d9baf2033853e9edbb34a46c25187151bd3926900d7711049"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kmj-007/lazygh/releases/download/v0.5.0/lazygh-x86_64-apple-darwin.tar.gz"
      sha256 "8feb2cc91f3f6ee8fcbbded23403bb8cd8568a60b3918f43a70e08bd859e111b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kmj-007/lazygh/releases/download/v0.5.0/lazygh-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4a7c503a2a9c15c5eb5788bb376646975bb7064e2632dc9d38d814bcc3d3d121"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lazygh" if OS.mac? && Hardware::CPU.arm?
    bin.install "lazygh" if OS.mac? && Hardware::CPU.intel?
    bin.install "lazygh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
