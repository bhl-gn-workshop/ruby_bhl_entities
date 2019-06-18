#!/usr/bin/env ruby

ROOT = File.dirname(File.dirname(__FILE__))
require ROOT + '/environment.rb'

TITLE_IDS = (0..10).to_a

def main
  logger = Logger.new($stdout)
  output = CSV.open('outputs/names.csv', 'w:utf-8')
  output << ['TitleId', 'PageId', 'Item', 'Start', 'End']

  stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
	opts = Protob::PagesOpt.new(with_text: true, title_ids: TITLE_IDS)  
  
  stub.pages(opts).each_with_index do |p, i|
    p.names.each do |n|
      output << [p.title_id, p.id, n.value, n.offset_start, n.offset_end]
    end
    logger.info("Process #{i} pages")
  end

  output.close
end

main