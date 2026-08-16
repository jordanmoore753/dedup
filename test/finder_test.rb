require "minitest/autorun"
require "tmpdir"
require_relative "../lib/dup_assets/finder"

class FinderTest < Minitest::Test
  def write(dir, filename, content)
    path = File.join(dir, filename)
    File.write(path, content)
    path
  end

  def test_no_duplicates
    Dir.mktmpdir do |dir|
      write(dir, "a.png", "aaa")
      write(dir, "b.png", "bbb")
      assert_empty DupAssets::Finder.call(dir)
    end
  end

  def test_identical_files_in_different_dirs
    Dir.mktmpdir do |dir|
      sub1 = File.join(dir, "team1"); Dir.mkdir(sub1)
      sub2 = File.join(dir, "team2"); Dir.mkdir(sub2)
      write(sub1, "icon.png", "same content")
      write(sub2, "icon.png", "same content")
      groups = DupAssets::Finder.call(dir)
      assert_equal 1, groups.size
      assert_equal 2, groups.first.size
    end
  end

  def test_three_way_duplicate
    Dir.mktmpdir do |dir|
      3.times { |i| write(dir, "icon#{i}.png", "same") }
      groups = DupAssets::Finder.call(dir)
      assert_equal 1, groups.size
      assert_equal 3, groups.first.size
    end
  end

  def test_two_separate_duplicate_pairs
    Dir.mktmpdir do |dir|
      2.times { |i| write(dir, "a#{i}.png", "content-a") }
      2.times { |i| write(dir, "b#{i}.png", "content-b") }
      assert_equal 2, DupAssets::Finder.call(dir).size
    end
  end

  def test_unique_file_not_included
    Dir.mktmpdir do |dir|
      write(dir, "unique.png", "only one")
      write(dir, "dup1.png", "same")
      write(dir, "dup2.png", "same")
      groups = DupAssets::Finder.call(dir)
      assert_equal 1, groups.size
      groups.first.each { |p| refute_match(/unique/, p) }
    end
  end

  def test_ignores_non_asset_files
    Dir.mktmpdir do |dir|
      write(dir, "script.rb", "same content")
      write(dir, "helper.rb", "same content")
      assert_empty DupAssets::Finder.call(dir)
    end
  end

  def test_svgs_differing_only_by_id_are_not_flagged
    Dir.mktmpdir do |dir|
      write(dir, "a.svg", '<svg id="export-1"><path d="M0 0"/></svg>')
      write(dir, "b.svg", '<svg id="export-2"><path d="M0 0"/></svg>')
      assert_empty DupAssets::Finder.call(dir)
    end
  end

  def test_symlinks_not_flagged
    Dir.mktmpdir do |dir|
      real = write(dir, "icon.png", "content")
      File.symlink(real, File.join(dir, "icon_link.png"))
      assert_empty DupAssets::Finder.call(dir)
    end
  end

  def test_empty_directory
    Dir.mktmpdir do |dir|
      assert_empty DupAssets::Finder.call(dir)
    end
  end

  def test_single_file
    Dir.mktmpdir do |dir|
      write(dir, "solo.png", "alone")
      assert_empty DupAssets::Finder.call(dir)
    end
  end
end
