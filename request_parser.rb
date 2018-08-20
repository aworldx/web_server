require './city_clock'

module RequestParser
  def self.parse(request)
    method, full_path = request.split(' ')
    path, query = full_path.split('?')

    case path
    when '/time'
      zones = ['UTC']
      zones += query.split(',').map do
        |el| CGI::unescape(el).split(' ').join('_')
      end unless query.blank?

      return ['200', {'Content-Type' => 'text/html'}, CityClock::get_time_utc(zones)]
    else
      return ['200', {'Content-Type' => 'text/html'}, ["Hello world!"]]
    end
  end
end
