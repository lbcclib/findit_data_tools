module FindItData
    def record_providers
        return {
            'opentextbooks' => {
                'record_provider_facet' => 'Open Textbook Library',
                'fetch_method' => 'http',
                'fetch_url' => 'https://open.umn.edu/opentextbooks/download.marc',
                'file_prefix' => 'opentextbooks',
                'traject_configuration_files' => ['lib/traject/opentextbooks.config.rb'],
                },
            'jomi' => {
                'record_provider_facet' => 'JoMI Surgical Videos',
                'fetch_method' => 'http',
                'fetch_url' => 'https://jomi.com/jomiRecords.mrc',
                'file_prefix' => 'jomi',
                'traject_configuration_files' => ['lib/traject/opentextbooks.config.rb','lib/traject/proxy.config.rb'],
                },
            'eg' => {
                'traject_configuration_files' => ['lib/traject/eg_lbcc.config.rb'],
                },
        }
    end

end
