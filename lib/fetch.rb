module FindItData
    require 'net/ftp'
    require 'net/http'
    require 'time'

    # Fetches a MARC file given the URL and the prefix you'd like to save it to
    def fetch_http urls, prefix, opts = {}
        if urls.kind_of? Proc
            urls_to_fetch = [urls.call].flatten(1)
	else
            urls_to_fetch = [urls].flatten(1)
	end
        files_written = []
        filename = 'new/' + prefix + '_' + date_downloaded + '.mrc'
        if File.exist? filename
            File.delete filename
        end
        urls_to_fetch.each do |url|
	    uri = URI url
            http = Net::HTTP.new(uri.hostname, uri.port)
            request = Net::HTTP::Get.new(uri.path)
            if opts.key? 'user'
                request.basic_auth opts['user'], opts['pass']
            end
            res = http.request request
            open(filename, 'ab') do |file|
                file.write res.body
            end
            files_written << (filename)
        end
        return files_written.uniq
    end

    def fetch_ftp server, prefix, credentials, opts = {}
        files_written = []
        ftp = Net::FTP.new server
	ftp.passive = true
        ftp.login credentials['user'], credentials['password']
        files = ftp.chdir('metacoll/out/ongoing/new')
        files_written += fetch_latest_files_by_ftp ftp, 'new', prefix
        files = ftp.chdir('../updates')
        files_written += fetch_latest_files_by_ftp ftp, 'update', prefix
        files = ftp.chdir('../deletes')
        files_written += fetch_latest_files_by_ftp ftp, 'delete', prefix
        return files_written
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
                filename = directory + '/' + prefix + '_' + date_downloaded + '.mrc'
                puts file + ' is saving as ' + filename
                ftp.getbinaryfile(file, filename)
                files_written << filename
            end
        end
        return files_written
    end

end
