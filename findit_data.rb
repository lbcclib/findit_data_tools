# Check the arguments

require './lib/delete'
require './lib/fetch'
require './lib/index'
require './lib/record_providers'
include FindItData

def print_usage_tips
    puts "Usage: ruby findit_data.rb -fi oclc"
    abort
end

unless 2 == ARGV.size
    print_usage_tips
end

unless ARGV[0].include? '-'
    print_usage_tips
end

if ARGV[0].include? 'd' or ARGV[0].include? 'r'
    puts "Deleting all that stuff"
    FindItData::delete_by_query 'record_provider_facet', FindItData::record_providers[ARGV[1]]['record_provider_facet']
end


if ARGV[0].include? 'f' or ARGV[0].include? 'r'
    puts "Fetching the file"
    if FindItData::record_providers.include? ARGV[1]
        puts "Fetching the file"
        file_name = FindItData::fetch_http FindItData::record_providers[ARGV[1]]['fetch_url'], FindItData::record_providers[ARGV[1]]['file_prefix']
    end
end

if ARGV[0].include? 'i' or ARGV[0].include? 'r'
    unless defined? file_name
        file_name = ARGV[2]
    end
    puts "Indexing the file"
    FindItData::index file_name, FindItData::record_providers[ARGV[1]]['traject_configuration_files']
end

