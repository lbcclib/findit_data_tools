require 'traject'

to_field 'record_provider_facet', literal('Gale Article Databases')
to_field 'record_source_facet' do |record, accumulator|
    gale_id = record['001']
    if gale_id.to_s.include? 'OVIC'
        accumulator << 'Opposing Viewpoints in Context'
    elsif gale_id.to_s.include? 'UHIC'
        accumulator << 'U.S. History In Context'
    elsif gale_id.to_s.include? 'ocm'
        accumulator << 'National Geographic Magazine Archive'
    end
end
to_field 'is_electronic_facet', literal('Online')
to_field 'format', literal('Research guide') # This should also depend on the record
to_field 'url_fulltext_display' do |record, accumulator|
    urls = record.find_all {|f| f.tag == '856'}
    urls.each do |field|
        value = field['u'].to_s
        if value.include? 'prod=NGMA'
            accumulator << 'http://ezproxy.libweb.linnbenton.edu:2048/login?url=http://infotrac.galegroup.com/itweb/lbcc?db=NGMA'
        else
            accumulator << value.gsub(/userGroupName\=\[LOCATIONID\]/, 'u=oregongeo')
        end
    end

end
