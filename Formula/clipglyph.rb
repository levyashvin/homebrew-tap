class Clipglyph < Formula
  desc "Clipboard OCR for macOS without Screen Recording permission or admin password"
  homepage "https://github.com/levyashvin/ClipGlyph"
  url "https://github.com/levyashvin/ClipGlyph/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cee472502396dd085de258529c59138e9a42bbb649d47ec5b358ad3857cc1f69"
  license "MIT"
  head "https://github.com/levyashvin/ClipGlyph.git", branch: "main"

  depends_on macos: :ventura

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    app = prefix/"ClipGlyph.app/Contents"
    (app/"MacOS").install ".build/release/ClipGlyph"
    app.install "Resources/Info.plist"
    system "codesign", "--force", "-s", "-", "--identifier", "io.github.levyashvin.clipglyph", prefix/"ClipGlyph.app"
  end

  service do
    run [opt_prefix/"ClipGlyph.app/Contents/MacOS/ClipGlyph"]
    process_type :interactive
  end

  def caveats
    <<~EOS
      Start ClipGlyph now and at every login:
        brew services start clipglyph

      Usage: copy a screenshot to the clipboard (e.g. ⌃⌘⇧4), press ⌃⌥⌘O, then paste.
      Settings: press ⌃⌥⌘, or run: open #{opt_prefix}/ClipGlyph.app
    EOS
  end

  test do
    assert_predicate prefix/"ClipGlyph.app/Contents/MacOS/ClipGlyph", :executable?
  end
end
