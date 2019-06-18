#!/usr/bin/env ruby

ROOT = File.dirname(File.dirname(__FILE__))
require ROOT + '/environment.rb'

def main
	logger = Logger.new($stdout)
  output = nil
	stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
	opts = Protob::PagesOpt.new(with_text: true)
	title_id = nil
	stub.pages(opts).each_with_index do |p, i|

		if title_id.nil?
			title_id = p.title_id
      FileUtils.mkdir_p "outputs/#{title_id}"
      output = File.open("outputs/#{title_id}/ocr.txt", 'w')
		elsif p.title_id != title_id
      output.close
			title_id = p.title_id
      FileUtils.mkdir_p "outputs/#{title_id}"
      output = File.open("outputs/#{title_id}/ocr.txt", 'w')
		end

    output.write("BHL_PAGE_START: #{p.id}\n")
    output.write(p.text)
    stdout, stderr, status = Open3.capture3("./geoparser/scripts/run -t plain -g unlock", stdin_data: p.text)
    xml = Nokogiri::XML(stdout)
    places = []
    people = []
    xml.search("ent[type='location']").each do |place|
      places << { gazref: place[:gazref], lat: place[:lat], long: place[:long], name: place.xpath("parts/part").text }
    end
    xml.search("ent[type='person']").each do |person|
      people << person.xpath("parts/part").text
    end
    output.write("PLACES: #{places}\n")
    output.write("PEOPLE: #{people}\n")
    output.write("BHL_PAGE_END: #{p.id}\n")
		next unless (i % 100_000).zero?
		logger.info("Process #{i} pages")
	end
  output.close
end

main