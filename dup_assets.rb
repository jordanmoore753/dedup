require "digest"
require "find"

ASSET_EXTENSIONS = %w[.png .jpg .jpeg .gif .svg .ico .webp].freeze

def find_duplicate_assets(root)
  by_hash = Hash.new { |h, k| h[k] = [] }

  Find.find(root) do |path|
    next unless File.file?(path)
    next unless ASSET_EXTENSIONS.include?(File.extname(path).downcase)

    hash = Digest::SHA256.file(path).hexdigest
    by_hash[hash] << path
  end

  by_hash.values.select { |paths| paths.size > 1 }
end
