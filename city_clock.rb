require 'active_support/all'

module CityClock
  def self.get_time_utc(cities)
    result = []
    time_zones = ActiveSupport::TimeZone::MAPPING

    cities.each do |city|
      tz_identifier = time_zones.select do |value, key|
        key.downcase.include?(city.downcase)
      end

      next unless tz_identifier.present?

      time_zone = ActiveSupport::TimeZone.new(tz_identifier.keys.first)
      result << "#{city}: #{time_zone.now.strftime('%Y-%m-%d %H:%M:%S')}\r\n"
    end

    result
  end
end
