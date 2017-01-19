module FindItData
    require 'net/http'
    require 'time'

    # Fetches a MARC file given the URL and the prefix you'd like to save it to
    def fetch_http urls, prefix, opts = {}
        files_written = []
        if urls.kind_of? Array
            urls_to_fetch = urls
        else
            urls_to_fetch = [urls]
        end
        filename = prefix + '_' + date_downloaded + '.mrc'
        if File.exist? filename
            File.delete filename
        end
        urls_to_fetch.each do |url|
            if url.kind_of? Proc
                uri = URI url.call
            else
                uri = URI url
            end
            http = Net::HTTP.new(uri.hostname, uri.port)
            request = Net::HTTP::Get.new(uri.path)
            if opts.key? 'user'
                request.basic_auth opts['user'], opts['pass']
            end
            res = http.request request
            open(filename, 'ab') do |file|
                file.write res.body
                files_written << filename
            end
        return files_written.uniq
        end
    end

    private
    def date_downloaded
        return DateTime.now.strftime('%F-%H-%M-%S')
    end

end
