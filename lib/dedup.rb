require_relative "dedup/finder"
require_relative "dedup/reporter"

module Dedup
  DEFAULT_ROOT = "app/assets"

  private_constant :DEFAULT_ROOT

  def self.call(root = DEFAULT_ROOT)
    groups = Finder.call(root)
    Reporter.call(groups)
  end
end
