class TerminalPoker < Formula
  desc "Heads-up No-Limit Texas Hold'em poker for the terminal"
  homepage "https://github.com/ashxudev/terminal-poker"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ashxudev/terminal-poker/releases/download/v1.0.1/terminal-poker-aarch64-apple-darwin.tar.xz"
      sha256 "835bd35cf0ee86f4594bf7f4282cc18898df7ab301f73b51f78928171a5620a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ashxudev/terminal-poker/releases/download/v1.0.1/terminal-poker-x86_64-apple-darwin.tar.xz"
      sha256 "315264618d96ae96e66aeb5797bbbeda1ecb471e100f76b3565f6982f14bef52"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ashxudev/terminal-poker/releases/download/v1.0.1/terminal-poker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b8925511a881c1fc2b88d34a5ad1817177768b582b95ff22bfeb1345c9aeb3f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ashxudev/terminal-poker/releases/download/v1.0.1/terminal-poker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d5e28d6d049757021aeb258ff6eb3e7eea56ce13b07a29d1b22b58e77be138e2"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "poker", "terminal-poker" if OS.mac? && Hardware::CPU.arm?
    bin.install "poker", "terminal-poker" if OS.mac? && Hardware::CPU.intel?
    bin.install "poker", "terminal-poker" if OS.linux? && Hardware::CPU.arm?
    bin.install "poker", "terminal-poker" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
