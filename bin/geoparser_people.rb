#!/usr/bin/env ruby

ROOT = File.dirname(File.dirname(__FILE__))
require ROOT + '/environment.rb'

TITLE_IDS = (0..10).to_a

def main
  logger = Logger.new($stdout)
  output = CSV.open('outputs/geoparser_people.csv', 'w:utf-8')
  output << ['TitleId', 'PageId', 'Person']

  stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
	opts = Protob::PagesOpt.new(with_text: true, title_ids: TITLE_IDS)  
  
  stub.pages(opts).each_with_index do |p, i|
    stdout, stderr, status = Open3.capture3("./geoparser/scripts/run -t plain -g unlock", stdin_data: p.text)
    xml = Nokogiri::XML(stdout)
    people = []
    xml.search("ent[type='person']").each do |person|
      people << person.xpath("parts/part").text
    end
    output << [p.title_id, p.id, people] if !people.empty?
    logger.info("Process #{i} pages")
  end

  output.close
end

main