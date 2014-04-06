#!/usr/bin/env ruby

require 'optparse'
require 'nokogiri'

# Generate MEAD docsent and cluster files for multi-doc summarization approach

# wrap text content with CDATA
def wrap_cdata(xml)
	xml.css('Title,UserID,SText').each do | node |
		cdata = Nokogiri::XML::CDATA.new xml, node.content
		node.content = ""
		node.add_child cdata
	end
end


def build_docsent(thread_id, post, post_idx)
	doc_id = "#{thread_id}_#{post_idx}"
	docsent = Nokogiri::XML::Builder.new do |xml|
		xml.DOCSENT(:DID => doc_id) {
			xml.BODY {
				xml.HEADLINE { "TODO" }
				xml.TEXT {
					sentences = post.css("Sentence")
					sentences.each do |sentence|
						sno = sentences.index(sentence) + 1
						xml.S(:PAR => "1",:RSNT => "#{sno}", :SNO => "#{sno}") { xml.cdata sentence.at_css("SText").content }
					end
				}
			}
		}
	end
	puts docsent.to_xml
	return docsent
end

options = {}
op = OptionParser.new do |opts|
	opts.on("-o", "--output PATH", "Output directory") do |path|
		options[:out_path] = path
	end
end
op.parse!(ARGV)


ARGV.each do |fname|
	f = File.open(fname)
	in_xml = Nokogiri::XML(f)
	f.close

	thread_id = in_xml.at_css("ThreadID").content
	cluster_path = options[:out_path]
	ds_path = options[:out_path]

	# create cluster file
	cluster = Nokogiri::XML::Builder.new do |xml|
		xml.CLUSTER(:LANG => "ENG") {
			posts = in_xml.css("InitPost,Post")
			posts.each do |post|
				post_idx = posts.index(post) + 1
				doc_id = "#{thread_id}_#{post_idx}"
				xml.D(:DID => "#{post_idx}")
				docsent = build_docsent(thread_id, post, post_idx)
				File.open(File.join(ds_path, "#{doc_id}.docsent"), 'w') { |f| f.write(docsent.to_xml) }
			end
		}
	end
	File.open(File.join(cluster_path, "#{thread_id}.cluster"), 'w') { |f| f.write(cluster.to_xml) }
end