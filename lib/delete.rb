module FindItData
    require 'net/http'
    def delete_by_query facet, value
        delete_xml = '<delete><query>' + facet + ':"' + value + '"</query></delete>'
        delete_url = 'http://localhost:8983/solr/blacklight-core/update?stream.body=' + delete_xml + '&commit=true'
        Net::HTTP.get(URI(delete_url))
    end
end
