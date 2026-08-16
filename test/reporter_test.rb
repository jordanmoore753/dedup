require "minitest/autorun"
require "tmpdir"
require_relative "../lib/dup_assets/reporter"

class ReporterTest < Minitest::Test
  def write(dir, filename, content)
    path = File.join(dir, filename)
    File.write(path, content)
    path
  end

  def test_no_duplicates_prints_to_stdout
    out, _ = capture_io { DupAssets::Reporter.call([]) }
    assert_includes out, "No duplicate assets found."
  end

  def test_no_duplicates_produces_no_stderr
    _, err = capture_io { DupAssets::Reporter.call([]) }
    assert_empty err
  end

  def test_no_duplicates_returns_exit_clean
    exit_code = nil
    capture_io { exit_code = DupAssets::Reporter.call([]) }
    assert_equal 0, exit_code
  end

  def test_duplicates_found_returns_exit_duplicates_found
    Dir.mktmpdir do |dir|
      a = write(dir, "a.png", "same")
      b = write(dir, "b.png", "same")
      exit_code = nil
      capture_io { exit_code = DupAssets::Reporter.call([[a, b]]) }
      assert_equal 1, exit_code
    end
  end

  def test_duplicate_paths_printed_to_stderr
    Dir.mktmpdir do |dir|
      a = write(dir, "a.png", "same")
      b = write(dir, "b.png", "same")
      _, err = capture_io { DupAssets::Reporter.call([[a, b]]) }
      assert_includes err, a
      assert_includes err, b
    end
  end

  def test_wasted_mb_printed_to_stderr
    Dir.mktmpdir do |dir|
      a = write(dir, "a.png", "x" * 1_048_576)
      b = write(dir, "b.png", "x" * 1_048_576)
      _, err = capture_io { DupAssets::Reporter.call([[a, b]]) }
      assert_includes err, "Wasted: 1.0 MB"
    end
  end
end
