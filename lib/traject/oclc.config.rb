require 'traject'
require 'lbcc_format_classifier'
extend Traject::Macros::LbccFormats

ebook_providers = [
    'Wright American Fiction',
    'Brandeis University Press Open Access Ebooks',
    'All EBSCO eBooks',
    'Directory of Open Access Books',
    'Credo Academic Core',
    'NCBI Bookshelf',
]

needs_fod_url_changes = [
    'Films on Demand',
    'Films on Demand: Archival Films & Newsreels Collection - Academic',
    'Films on Demand: Master Career and Technical Education Collection - Academic',
]

needs_proxy = [
    'All EBSCO eBooks',
    'American History in Video United States',
    'ebrary Academic Complete',
    'Music Online: Classical Music Library - United States',
    'Music Online: Smithsonian Global Sound for Libraries',
]

streaming_music_providers = [
    'Music Online: Classical Music Library - United States',
    'Music Online: Smithsonian Global Sound for Libraries',
]

streaming_video_providers = [
    'American History in Video United States',
    'Films on Demand',
    'Films on Demand: Archival Films & Newsreels Collection - Academic',
    'Films on Demand: Master Career and Technical Education Collection - Academic',
]

to_field 'record_provider_facet', literal('OCLC')
to_field 'record_source_facet', extract_marc('950a')
to_field 'is_electronic_facet', literal('Cat')

to_field 'format' do |record, accumulator|
    db = record['950']['a'].to_s
    if ebook_providers.include? db
        accumulator << 'Ebook'
    elsif streaming_video_providers.include? db
        accumulator << 'Streaming video' 
    elsif streaming_music_providers.include? db
        accumulator << 'Streaming music' 
    else
        accumulator << Traject::Macros::LbccFormatClassifier.new(record).formats[0]
    end
end

to_field 'url_fulltext_display' do |record, accumulator|
    db = record['950']['a'].to_s
    urls = record.find_all {|f| f.tag == '856'}
    urls.each do |field|
        value = field['u']
        if needs_proxy.include? db
            accumulator << "http://ezproxy.libweb.linnbenton.edu:2048/login?url=#{value}"
        elsif needs_fod_url_changes.include? db
            accumulator << 'http://ezproxy.libweb.linnbenton.edu:2048/login?url=' + value.sub('aid=', 'aid=4065').sub('portalPlaylists', 'PortalPlaylists') + '&cid=1639'
        else
            accumulator << value
        end
    end
end

