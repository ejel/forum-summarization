#!/usr/bin/env ruby

# Sanitize raw XML forum data so that it is valid XML document.
# Specifically wrap all text value elements in CDATA so that characters
# do not have to be escaped.


require 'nokogiri'

# wrap text content with CDATA
def wrap_cdata(xml)
	xml.css('Title,UserID,SText').each do | node |
		cdata = Nokogiri::XML::CDATA.new xml, node.content
		node.content = ""
		node.add_child cdata
	end
end


ARGV.each do |fname|
	f = File.open(fname)
	xml_doc = Nokogiri::XML(f)
	f.close
	wrap_cdata(xml_doc)
	File.open(fname, 'w') { |f| f.write(xml_doc.to_xml) }
end

