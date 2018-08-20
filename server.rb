require './request_parser'
require 'socket'

server = TCPServer.new 5678

loop {
  Thread.start(server.accept) do |session|
    request = session.gets
    status, headers, body = RequestParser::parse(request)

    session.print "HTTP/1.1 #{status}\r\n"

    headers.each do |key, value|
      session.print "#{key}: #{value}\r\n"
    end

    session.print "\r\n"

    body.each do |part|
      session.print part
    end

    session.close
  end
}
