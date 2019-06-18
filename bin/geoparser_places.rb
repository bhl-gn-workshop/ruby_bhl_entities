#!/usr/bin/env ruby

ROOT = File.dirname(File.dirname(__FILE__))
require ROOT + '/environment.rb'

TITLE_IDS = (0..10).to_a

def main
  logger = Logger.new($stdout)
  output = CSV.open('outputs/geoparser_places.csv', 'w:utf-8')
  output << ['TitleId', 'PageId', 'Place', 'Latitude', 'Longitude', 'gazref']

  stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
	opts = Protob::PagesOpt.new(with_text: true, title_ids: TITLE_IDS)
  
  stub.pages(opts).each_with_index do |p, i|
    stdout, stderr, status = Open3.capture3("./geoparser/scripts/run -t plain -g unlock", stdin_data: p.text)
    xml = Nokogiri::XML(stdout)
    xml.search("ent[type='location']").each do |place|
      output << [p.title_id, p.id, place.xpath("parts/part").text, place[:lat], place[:long], place[:gazref]]
    end
    logger.info("Process #{i} pages")
  end

  output.close
end

main