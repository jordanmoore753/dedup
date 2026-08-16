module Dedup
  module Reporter
    BYTES_PER_MB = 1_048_576.0
    EXIT_CLEAN = 0
    EXIT_DUPLICATES_FOUND = 1

    private_constant :BYTES_PER_MB
    private_constant :EXIT_CLEAN
    private_constant :EXIT_DUPLICATES_FOUND

    def self.call(groups)
      if groups.empty?
        puts "No duplicate assets found."
        return EXIT_CLEAN
      end

      groups.each do |group|
        warn "Duplicates:"
        group.each { |path| warn "  #{path}" }
      end

      warn "\nWasted: #{(wasted_bytes(groups) / BYTES_PER_MB).round(1)} MB"
      EXIT_DUPLICATES_FOUND
    end

    def self.wasted_bytes(groups)
      groups.sum { |g| File.size(g.first) * (g.size - 1) }
    end

    private_class_method :wasted_bytes
  end
end
