class Clipglyph < Formula
  desc "Clipboard OCR for macOS without Screen Recording permission or admin password"
  homepage "https://github.com/levyashvin/ClipGlyph"
  url "https://github.com/levyashvin/ClipGlyph/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a16e0c83c4d80f44357fa6d3fb1566635bb8abb4dd56ad0687d9928aa714a84d"
  license "MIT"
  head "https://github.com/levyashvin/ClipGlyph.git", branch: "main"

  depends_on macos: :ventura

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    app = prefix/"ClipGlyph.app/Contents"
    (app/"MacOS").install ".build/release/ClipGlyph"
    app.install "Resources/Info.plist"
    system "codesign", "--force", "--options", "runtime", "-s", "-", "--identifier", "io.github.levyashvin.clipglyph", prefix/"ClipGlyph.app"
  end

  service do
    run [opt_prefix/"ClipGlyph.app/Contents/MacOS/ClipGlyph"]
    keep_alive crashed: true
    process_type :interactive
  end

  def caveats
    <<~EOS
      Start ClipGlyph now and at every login:
        brew services start clipglyph

      Quit from the menu bar icon to stop until next login; `brew services stop clipglyph` to stop for good.

      Usage: copy a screenshot to the clipboard (e.g. ⌃⌘⇧4), press ⌃⌥⌘O (changeable in Settings), then paste.
      Settings: menu bar icon, or run: open #{opt_prefix}/ClipGlyph.app
    EOS
  end

  test do
    assert_predicate prefix/"ClipGlyph.app/Contents/MacOS/ClipGlyph", :executable?
  end
end
