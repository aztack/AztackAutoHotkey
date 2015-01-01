#encoding:utf-8
require 'win32/clipboard'
require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'pp'
require 'pry'

class ::String
	def gbk
		self.force_encoding 'gbk'
	end
end

q = ARGV.join(" ").force_encoding('gbk')
$doc = nil
$links = nil
p = 0

def fetch(q, p = 0)
	open("http://btdigg.org/search?q=#{URI.escape(q)}&p=#{p}") do |f|
		$links = {}
		$doc = Nokogiri::HTML(f.read)
		$doc.css('#search_res tr').each do |tr|
			index = tr.css('.idx').text.gbk
			next if index.empty?
			title = tr.css('.torrent_name a').text.gbk
			attrs = tr.css('.attr_name').map{|e|e.text}
			values = tr.css('.attr_val').map{|e|e.text.gsub("\u00A0","")}
			snippet = tr.css('.snippet').text.gsub(/^/,"  ")

			$links[index] = tr.css("a[href*=magnet]").first.attr('href').to_s.gbk

			$stdout.puts sprintf("%s %s\n [%s]", index, title, Hash[attrs.zip(values)].to_s[1..-2].gbk.gsub(':"=>"',': '))
			$stdout.puts snippet
			$stdout.puts
		end
	end
end

fetch(q, 0)

s = $stdin.gets.strip
if s =~/(\d+)/
	Win32::Clipboard.set_data($links[$1])
elsif s =~ /k/i
	fetch(q, p+=1)
elsif s =~ /j/i
	fetch(q, p-=1)
end