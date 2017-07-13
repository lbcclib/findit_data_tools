require 'open-uri'
require 'traject'

to_field 'authority_data_t' do |record, accumulator|
	authorizable_fields = record.find_all {|f| ['100', '110', '111', '600', '610', '611', '630', '650', '651', '700', '710', '711', '730', '800', '810', '811', '830'].include? f.tag }
	authorizable_fields.each do |field|
		authorized_subfields = field.find_all {|subfield| subfield.code == '0'}
		authorized_subfields.each do |subfield|
			control_no = subfield.value.delete("^0-9")
			eg_authority_url = "http://libcat.linnbenton.edu/opac/extras/supercat/retrieve/marcxml/authority/#{control_no}"
			begin
				open(eg_authority_url) do |ar|
					reader = MARC::XMLReader.new(ar)
					for arecord in reader
						interesting_authority_fields = arecord.find_all {|f| ['400', '410', '411', '430', '447', '448', '450', '451', '455', '500', '510', '511', '530', '550', '551', '555', '663', '664', '665', '666', '680', '681', '682', '700', '710', '711', '730', '747', '748', '750', '751', '755', '780', '781', '782'].include? f.tag}
						interesting_authority_fields.each do |afield|
							afield.each do |asubfield|
								unless '0' == asubfield.code
									accumulator << asubfield.value
								end
							end
						end
					end
				end
			rescue
			end
		end
	end
end


