require 'traject'

to_field 'record_provider_facet', literal('Open Textbook Library')
to_field 'record_source_facet', literal('Open Textbook Library')
to_field 'is_electronic_facet', literal('Online')
to_field 'format', literal('Ebook')
to_field 'url_fulltext_display',
                                extract_marc("856|40|u")
to_field 'url_fulltext_display',
                                extract_marc("856|42|u")
