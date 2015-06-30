#!/usr/bin/env ruby

# based on example @
# https://stackoverflow.com/questions/2062051/how-do-i-parse-an-html-table-with-nokogiri

require 'nokogiri'
require 'descriptive_statistics'

html = File.read 'Zero-K.html'

doc = Nokogiri::HTML(html)
rows = doc.xpath('/html/body/div[3]/div[4]/table[4]/tbody/tr')
details = rows.collect do |row|
  detail = {}
  [
    [:date, 'td[1]/text()'],
    [:name, 'td[2]/a[2]/text()'],
    [:ammount, 'td[3]/text()'],
  ].each do |name, xpath|
    detail[name] = row.at_xpath(xpath).to_s.strip
  end
  detail[:ammount] = detail[:ammount].sub('€', '').to_f
  detail
end

donations = details.collect do |row|
  row[:ammount]
end

puts 'mean: €%.2f' % donations.mean
puts 'median: €%.2f' % donations.median
puts 'stddev: €%.2f' % donations.standard_deviation
puts 'min: €%.2f' % donations.min
puts 'max: €%.2f' % donations.max

(10..100).step(10).each do |n|
  puts 'percentile %d: €%.2f' % [n, donations.percentile(n)]
end
