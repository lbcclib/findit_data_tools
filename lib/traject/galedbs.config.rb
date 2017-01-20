require 'traject'

to_field 'record_provider_facet', literal('Gale Article Databases')
to_field 'record_source_facet' do |record, accumulator|
    gale_id = record['001']
    if gale_id.to_s.include? 'OVIC'
        accumulator << 'Opposing Viewpoints in Context'
    elsif gale_id.to_s.include? 'AHIC'
        accumulator << 'American History in Context'
    elsif gale_id.to_s.include? 'NGMA'
        accumulator << 'National Geographic Magazine Archive'
    end
end
to_field 'is_electronic_facet', literal('Online')
to_field 'format', literal('Research guide') # This should also depend on the record
