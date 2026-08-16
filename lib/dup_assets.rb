require_relative "dup_assets/finder"
require_relative "dup_assets/reporter"

module DupAssets
  DEFAULT_ROOT = "app/assets"

  private_constant :DEFAULT_ROOT

  def self.call(root = DEFAULT_ROOT)
    groups = Finder.call(root)
    Reporter.call(groups)
  end
end
