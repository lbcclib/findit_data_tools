require 'traject'
require 'lbcc_format_classifier'
extend Traject::Macros::LbccFormats


to_field 'record_provider_facet', literal('LBCC Evergreen Catalog')
to_field 'record_source_facet', literal('LBCC Library Catalog')
to_field 'is_electronic_facet' do |record, accumulator|
	field852s = record.find_all {|f| f.tag == "852"}
	field852s.each do |field|
		library = field['b']
		if "LBCCHOC" == library
			accumulator << "Healthcare Occupations Center"
		elsif "LBCCLIB" == library
			accumulator << "Albany Campus Library"
		elsif "LBCC" == library
			accumulator << "Online"
		else
			accumulator << "Partner Libraries"
		end
	end
end


to_field 'format', lbcc_formats
to_field 'owning_lib_facet', extract_marc('852b')
