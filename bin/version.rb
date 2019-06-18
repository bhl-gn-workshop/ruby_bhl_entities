#!/usr/bin/env ruby
# encoding: utf-8

require File.dirname(File.dirname(__FILE__)) + '/environment.rb'

def main
  stub = Protob::BHLIndex::Stub.new('bhlrpc.globalnames.org:80', :this_channel_is_insecure)
  message = stub.ver(Protob::Void.new).value
  puts "Version: #{message}"
end

main