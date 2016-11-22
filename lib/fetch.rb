module FindItData
    require 'net/http'
    require 'time'

    # Fetches a MARC file given the URL and the prefix you'd like to save it to
    def fetch_http url, prefix
        uri = URI url
        Net::HTTP.start(uri.hostname, uri.port) do |http|
            res = http.get(uri.path)
            filename = prefix + '_' + date_downloaded + '.mrc'
            open(filename, 'wb') do |file|
                file.write res.body
                return filename
            end
        end
    end

    private
    def date_downloaded
        return Date.today.to_s
    end

end
