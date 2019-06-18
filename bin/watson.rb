#!/usr/bin/env ruby

ROOT = File.dirname(File.dirname(__FILE__))
require ROOT + '/environment.rb'
include IBMWatson

CONFIG = YAML.load_file('config.yml')

TITLE_IDS = (0..10).to_a

def main
  logger = Logger.new($stdout)

  output_places = CSV.open('outputs/watson_places.csv', 'w:utf-8')
  output_people = CSV.open('outputs/watson_people.csv', 'w:utf-8')

  output_places << ['TitleId', 'PageId', 'Item', 'Start', 'End']
  output_people << ['TitleId', 'PageId', 'Item', 'Start', 'End']

  stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
	opts = Protob::PagesOpt.new(with_text: true, title_ids: TITLE_IDS)

  natural_language_understanding = IBMWatson::NaturalLanguageUnderstandingV1.new(
    version: "2018-11-16",
    iam_apikey: "#{CONFIG["watson"]["apikey"]}",
    url: "#{CONFIG["watson"]["url"]}"
  )

  stub.pages(opts).each_with_index do |p, i|
    p.text = "The Falco berigora was confusingly located in Falco."
    content = "#{p.text}".force_encoding("UTF-8")
    if !content.nil? && !content.empty?
      begin
        response = natural_language_understanding.analyze(
          text: content,
          features: {
            entities: {
              mentions: true
            }
          }
        ).result
        response["entities"].each do |e|
          if e["type"] == "Location"
            next if e["mentions"].nil? || e["mentions"].size == 0
            e["mentions"].each do |m|
              output_places << [p.title_id, p.id, m["text"], m["location"][0], m["location"][1]]
            end
          elsif e["type"] == "Person"
            next if e["mentions"].nil? || e["mentions"].size == 0
            e["mentions"].each do |m|
              output_people << [p.title_id, p.id, m["text"], m["location"][0], m["location"][1]]
            end
          end
        rescue
          logger.info("My dear Watson we had a problem on #{i}.")
        end
      end
    end
    logger.info("Process #{i} pages")
  end

  output_places.close
  output_people.close
end

main