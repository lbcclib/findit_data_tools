# Check the arguments

require './lib/delete'
require './lib/fetch'
require './lib/index'
require './lib/record_providers'
include FindItData

def print_usage_tips
    puts "Usage: ruby findit_data.rb -fi oclc"
    puts
    puts "-d will remove the records from solr"
    puts "-f will fetch the records from the record provider"
    puts "-i will index the records in solr; you can pass a file to this option to index a field you've already downloaded (e.g. ruby findit_data.rb -i opentextbooks file.mrc)"
    puts "-r will do all of the above, resulting in a re-index"
    puts
    puts "List of record providers"
    FindItData::record_providers.each do |provider, details|
        puts provider
    end
    abort
end

if (2 > ARGV.size) or (3 < ARGV.size)
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
    Dir.mkdir 'new' unless File.exists? 'new'
    Dir.mkdir 'update' unless File.exists? 'update'
    Dir.mkdir 'delete' unless File.exists? 'delete'

    puts "Fetching the file"
    if FindItData::record_providers.include? ARGV[1]
        if 'http' == FindItData::record_providers[ARGV[1]]['fetch_method']
            if FindItData::record_providers[ARGV[1]].key? 'fetch_opts'
                file_names = FindItData::fetch_http FindItData::record_providers[ARGV[1]]['fetch_url'], FindItData::record_providers[ARGV[1]]['file_prefix'], FindItData::record_providers[ARGV[1]]['fetch_opts']
            else
                file_names = FindItData::fetch_http FindItData::record_providers[ARGV[1]]['fetch_url'], FindItData::record_providers[ARGV[1]]['file_prefix']
            end
        elsif 'ftp' == FindItData::record_providers[ARGV[1]]['fetch_method']
            file_names = FindItData::fetch_ftp FindItData::record_providers[ARGV[1]]['remote_server'], FindItData::record_providers[ARGV[1]]['file_prefix'], FindItData::record_providers[ARGV[1]]['credentials']
        end
    else
        print_usage_tips
    end
end

if ARGV[0].include? 'i' or ARGV[0].include? 'r'
    if file_names.nil?
        file_names = Array(ARGV[2])
    end
    FindItData::index file_names, FindItData::record_providers[ARGV[1]]['traject_configuration_files']
end

