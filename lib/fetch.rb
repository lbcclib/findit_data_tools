module FindItData
    require 'net/ftp'
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
        filename = 'new/' + prefix + '_' + date_downloaded + '.mrc'
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
        end
        return files_written.uniq
    end

    def fetch_ftp server, prefix, credentials, opts = {}
        files_written = []
        ftp = Net::FTP.new server
        ftp.login credentials['user'], credentials['password']
        files = ftp.chdir('metacoll/out/ongoing/new')
        files_written += fetch_latest_files_by_ftp ftp, 'new', prefix
        files = ftp.chdir('../updates')
        files_written += fetch_latest_files_by_ftp ftp, 'update', prefix
        files = ftp.chdir('../deletes')
        files_written += fetch_latest_files_by_ftp ftp, 'delete', prefix
   puts files_written
        ftp.close
    end

    private
    def date_downloaded
        return DateTime.now.strftime('%F-%H-%M-%S')
    end

    def fetch_latest_files_by_ftp ftp, directory, prefix
        files_written = []
        files = ftp.nlst('*.mrc')
        files.each do |file|
            if (Time.now - (7*24*60*60)) < (ftp.mtime file)
                puts file
                filename = directory + prefix + '_' + date_downloaded + '.mrc'
                ftp.getbinaryfile(file, filename)
                files_written << filename
            end
        end
    end

end
