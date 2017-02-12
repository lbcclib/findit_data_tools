require 'traject'
require 'lbcc_format_classifier'
extend Traject::Macros::LbccFormats


to_field 'record_provider_facet', literal('LBCC Evergreen Catalog')
to_field 'record_source_facet', literal('LBCC Library Catalog')
to_field 'is_electronic_facet', literal('At the Library')

to_field 'format', lbcc_formats
