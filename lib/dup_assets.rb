require_relative "dup_assets/finder"
require_relative "dup_assets/reporter"

module DupAssets
  def self.call(root)
    groups = Finder.call(root)
    Reporter.call(groups)
  end
end
