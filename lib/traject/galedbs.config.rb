require 'traject'

to_field 'record_provider_facet', literal('Gale Article Databases')
to_field 'record_source_facet', literal('Opposing Viewpoints in Context') # This should totally depend on the record
to_field 'is_electronic_facet', literal('Online')
to_field 'format', literal('Research guide') # This should also depend on the record

# Also, need to proxy these
