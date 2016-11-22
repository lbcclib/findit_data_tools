module FindItData
    def record_providers
        return {
            'opentextbooks' => {
                'record_provider_facet' => 'Open Textbook Library',
                'fetch_method' => 'http',
                'fetch_url' => 'http://open.umn.edu/opentextbooks/MARC/OTL20161101.mrc',
                'file_prefix' => 'opentextbooks',
                'traject_configuration_files' => ['lib/traject/opentextbooks.config.rb'],
                }
        }
    end

end
