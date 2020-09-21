# http://stackoverflow.com/questions/3852755/ruby-array-subtraction-without-removing-items-more-than-once
class Array
  # Subtract each passed value once:
  #   %w(1 2 3 1).subtract_once %w(1 1 2) # => ["2", "3"]
  # Time complexity of O(n + m)
  def subtract_once(values)
    counts = values.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
    reject { |e| counts[e] -= 1 unless counts[e].zero? }
  end
end



#require 'discordrb'
require 'nokogiri'
require 'open-uri'
bans = {}

#bot.run(true)
loop do
  bans_player= []
  File.open('test.txt') do |file|
    file.each_line do |subject|
      bans_player.push(subject.chomp)
    end
  end
  old_bans = bans
  bans = {}
  bans_player.each_slice(3) do |i,j,k|
    bans[i]="#{j} #{k}"
    puts "#{i} #{j} #{k}"
  end
  puts "--------------"
  puts "New: "
  p bans.keys.subtract_once(old_bans.keys)
  puts "--------------"
  sleep 1
end
