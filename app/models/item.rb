require 'open-uri'
require 'uri'
require 'net/http'
require 'builder'
require 'taglib'
require 'ftp'


class Item < ActiveRecord::Base
  belongs_to :user
  has_many :attachments



  def media_length(media)
    #f = self.attachments.new(audio: media)
    #f.save!

    file = media.tempfile
    TagLib::MPEG::File.open(file.path) do |file|
      properties = file.audio_properties
      length = properties.length
    end
  end




  def import(params, podcast)
    xml_from_ftp = ServerFTP.new(self.address, self.username, self.password)
    xml_from_ftp.setup



    xml_from_ftp.setDir(self.audio_dir)
    audio_length = xml_from_ftp.ftp.size(params[:audio])
    full_audio_path = self.link + "/" + self.audio_dir.split("/").last + "/" + params[:audio]
    xml_from_ftp.ftp.close



    xml_from_ftp = ServerFTP.new(self.address, self.username, self.password)
    xml_from_ftp.setup
    xml_from_ftp.setDir(self.podcast_dir)
    xml_from_ftp.grab(self.file_name)

    original = Nokogiri::XML(File.read(self.file_name))
    items = original.xpath("//item")[0]

    buffer = ""
    builder = ::Builder::XmlMarkup.new(:target=>buffer, :indent=>6)
    builder.item { |b|
                  b.title(params[:title]);
                  b.itunes :author, podcast.author
                  b.tag! ("description") { b.cdata! podcast.cdata }
                  b.itunes :subtitle, params[:subtitle]
                  b.itunes :summary, podcast.cdata
                  b.enclosure :url => full_audio_path,  :length => (audio_length), :type => params[:file_type]
                  b.link(podcast.link);
                  b.guid(full_audio_path);
                  b.pubDate(Time.parse(params[:pubDate]).strftime("%a, %d %b %Y %H:%M:%S %z"));
                  b.category("Podcasting");
                  b.explicit("No");
                  b.duration(params[:audio_file_duration]);
                  b.keywords(podcast.keywords);
                }
    items.add_previous_sibling(buffer)
    original.to_xml(:indent => 6)

    new_file = File.new(self.file_name, "w")
    new_file.write(original.to_xml)
    new_file.close

    xml_from_ftp.ftp.putbinaryfile(self.file_name)
    xml_from_ftp.ftp.close

  end


end
