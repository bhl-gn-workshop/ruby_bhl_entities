#!/usr/bin/env ruby

ROOT = File.dirname(File.dirname(__FILE__))
require ROOT + '/environment.rb'

CONFIG = YAML.load_file('config.yml')

TITLE_IDS = (0..10).to_a

def main
  logger = Logger.new($stdout)
  output = CSV.open('outputs/rosette.csv', 'w:utf-8')
  output << []

  rosette_api = RosetteAPI.new(CONFIG["rosette_key"])
  stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
  opts = Protob::PagesOpt.new(with_text: true, title_ids: TITLE_IDS)

  #TODO: reached limit in Rosette
  stub.pages(opts).each_with_index do |p, i|
    begin
      params = DocumentParameters.new(content: p.text)
      response = rosette_api.get_entities(params)
      puts JSON.pretty_generate(response)
    rescue
      printf("Rosette API Error")
    end
    logger.info("Process #{i} pages")
  end

  output.close
end

main