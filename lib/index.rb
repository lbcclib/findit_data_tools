require 'marc'
require './lib/delete'
module FindItData

    # Fetches a MARC file given the URL and the prefix you'd like to save it to
    def index files, configs
        config_string = ''
        configs.each do |config|
            config_string = config_string + '-c ' + config + ' '
        end
        files.each do |file|
            unless 'delete' == file[0,6]
                `traject -c lib/traject/config.rb #{config_string} -I lib/traject #{file} -s solrj_writer.commit_on_close=true`
            else
                 "sending some delete queries"
                 reader = MARC::Reader.new(file, :external_encoding => "UTF-8")
                 for record in reader
                     delete_by_query 'id', record['001'].value
                 end
            end
        end
    end

end
