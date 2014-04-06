#!/usr/bin/env ruby

# Create MEAD cluster file for single-document summarization.
# 1 document / cluster

require 'nokogiri'

ARGV.each do |f|
	fname = File.basename(f, ".*")
	path = File.dirname(f)
	builder = Nokogiri::XML::Builder.new do |xml|
		xml.CLUSTER(:LANG => "ENG") {
			xml.D(:DID => fname)
		}
	end
	File.open(File.join(path, "#{fname}.cluster"), "w") { |f| f.write(builder.to_xml) }
end
