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

########################################################
require 'discordrb'
require 'nokogiri'
require "dotenv"
require 'open-uri'
bans = {}
doc = Nokogiri::HTML(open('https://www.mcbans.com/server/61605/dekitateserver.com/'))
bans_player= []
doc.css('div#content tr td a').each do |link|
  bans_player.push link.children[0].content
end
old_bans = bans
bans = {}
bans_player.each_slice(3) do |i,j,k|
  bans[i]="#{j} #{k}"
  puts "#{i} #{j} #{k}"
end


ch = {}
Dotenv.load
bot = Discordrb::Bot.new(token: ENV["TOKEN"],client_id: 757567365171904583)

bot.ready() do |event|
  $bot = event.bot
  $bot.servers.each do |id,server|
    if ch[id]!=nil
      $bot.send_message(ch[id],"BOTが起動しました。")
    else
      $bot.send_message(server.system_channel,"BOTが起動しました。")
    end
  end
  puts "https://discord.com/api/oauth2/authorize?client_id=757567365171904583&permissions=2048&scope=bot"
end

bot.mention() do |event|
  event.channel.send("お前、BANされてやんのぉwwwざまみぃ⤴︎ ⤴︎ ")
end

bot.run(true)
loop do
  doc = Nokogiri::HTML(open('https://www.mcbans.com/server/61605/dekitateserver.com/'))
  bans_player= []
  doc.css('div#content tr td a').each do |link|
    bans_player.push link.children[0].content
  end
  old_bans = bans
  bans = {}
  bans_player.each_slice(3) do |i,j,k|
    bans[i]="#{j} #{k}"
    puts "#{i} #{j} #{k}"
  end
  puts "--------------"
  puts "New: "
  new = []
  bans.keys.subtract_once(old_bans.keys).each do |i|
    puts "#{i} #{bans[i]}"
    new.push("#{i} #{bans[i]}")
  end
  begin
    if new!=[]
      $bot.servers.each do |id,server|
        if ch[id]!=nil
          $bot.send_message(ch[id],"新しいBANを検出しました。\n\n#{new.join("\n")}")
        else
          $bot.send_message(server.system_channel,"新しいBANを検出しました。\n\n#{new.join("\n")}")
        end
      end
    end
  end
  puts "--------------"
  sleep 60
end
