#!/usr/bin/ruby
require 'open-uri'
require 'nokogiri'

links = {
  'ruby' => 'https://rubystyle.guide/',
  'rails' => 'https://rails.rubystyle.guide/',
  'rspec' => 'https://rspec.rubystyle.guide/'
}

def get_page link
  Nokogiri::HTML.parse URI.open(link)
end

def to_anki_format page
  page.search('div.sect2').map do |html|
    title = html.xpath('./h3').to_s
      .gsub '"', '""'

    content = html.xpath('./div').to_s
      .gsub '"', '""'

    "\"#{title}\";\"#{content}\""
  end.join "\n"
end

links.each do |key, value|
  file = 'ankistyle_' + key + '.txt'
  page = get_page value
  File.write file, to_anki_format(page)
end
