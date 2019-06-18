#!/usr/bin/env ruby

ROOT = File.dirname(File.dirname(__FILE__))
require ROOT + '/environment.rb'

def main
  logger = Logger.new($stdout)
  output = CSV.open('output.csv', 'w:utf-8')
  output << ['Id']
  stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
  stub.titles(Protob::TitlesOpt.new).each_with_index do |t, i|
    output << [t.id]
    logger.info("Process #{i} titles")
  end
  output.close
end

main