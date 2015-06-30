#!/usr/bin/env ruby

# based on example @
# https://stackoverflow.com/questions/2062051/how-do-i-parse-an-html-table-with-nokogiri

require 'nokogiri'

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

def mean(array)
  array.inject(:+).to_f / array.size
end

def median(array)
  sorted = array.sort
  len = sorted.length
  return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

puts 'mean: €%.2f' % mean(donations)
puts 'median: €%.2f' % median(donations)
puts 'min: €%.2f' % donations.min
puts 'max: €%.2f' % donations.max
