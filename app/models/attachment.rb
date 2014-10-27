class Attachment < ActiveRecord::Base

  belongs_to :item
  has_attached_file :audio

  validates_attachment_content_type :audio,
  :content_type => [ 'audio/mpeg', 'audio/mpg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ]






end
