#!/usr/bin/env ruby

require 'xmpp4r-observable'
#Jabber::debug = true

if ARGV.size < 3
  puts "Usage: #{$0} <superfeedr-jid> <superfeedr-password> <notifyees>"
  exit
end

jid, pw, $to = ARGV[0], ARGV[1], ARGV[2..-1]
jid = "#{jid}@superfeedr.com" unless jid.index('@')

$im = Jabber::Observable.new(jid, pw)
$im.status :xa, 'At your service!'

pubsub = Jabber::Observable::PubSub.new($im, 'firehoser.superfeedr.com')
o = Object.new
class << o
  def update(what, event)
    p :update => [what, event]
    notify event.to_s
  end
  def notify(text)
    $to.each do |jid|
      $im.deliver jid, text
    end
  end
end
$im.add_observer(:event, o)

puts "Running"
o.notify 'Up'
Thread.stop
