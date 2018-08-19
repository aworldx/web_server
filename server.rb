require 'socket'
require 'active_support/all'

server = TCPServer.new 5678

def get_time_utc(cities)
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

loop {
  Thread.start(server.accept) do |session|
    request = session.gets

    method, full_path = request.split(' ')
    path, query = full_path.split('?')

    case path
    when '/time'
      zones = ['UTC']
      zones += query.split(',').map { |el| CGI::unescape(el) } unless query.blank?
      response = get_time_utc(zones)
    else
      response = ["Hello world!"]
    end

    session.print "HTTP/1.1 200\r\n"
    session.print "Content-Type: text/html\r\n"
    session.print "\r\n"
    response.each { |resp| session.print resp }

    session.close
  end
}
