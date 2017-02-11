require 'traject'

to_field 'record_provider_facet', literal('OCLC')
to_field 'record_source_facet', extract_marc('950a')
