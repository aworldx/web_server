require './request_parser'
require 'eventmachine'

module EchoServer
  def receive_data(data)
    status, headers, body = RequestParser::parse(data)

    send_data "HTTP/1.1 #{status}\r\n"

    headers.each do |key, value|
      send_data "#{key}: #{value}\r\n"
    end

    send_data "\r\n"

    body.each do |part|
      send_data part
    end

    close_connection_after_writing
  end
end

EventMachine.run {
  EventMachine.start_server "127.0.0.1", 5678, EchoServer
}
