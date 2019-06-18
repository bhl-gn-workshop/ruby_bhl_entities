#!/usr/bin/env ruby

ROOT = File.dirname(File.dirname(__FILE__))
require ROOT + '/environment.rb'

def main
  logger = Logger.new($stdout)
  output = CSV.open('names.csv', 'w:utf-8')
  output << ['TitleId', 'PageId', 'Name', 'NameStart', 'NameEnd']

  stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
	opts = Protob::PagesOpt.new(with_text: true)  
  
  stub.pages(opts).each do |p|
    p.names.each do |n|
      output << [p.title_id, p.id, n.value, n.offset_start, n.offset_end]
    end
  end

  output.close
end

main