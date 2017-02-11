module FindItData

    # Fetches a MARC file given the URL and the prefix you'd like to save it to
    def index files, configs
        config_string = ''
        configs.each do |config|
            config_string = config_string + '-c ' + config + ' '
        end
        files.each do |file|
            unless 'delete' == file[0,5]
                `traject -c lib/traject/config.rb #{config_string} -I lib/traject #{file} -s solrj_writer.commit_on_close=true`
            else
                 'Delete'
            end
        end
    end

end
