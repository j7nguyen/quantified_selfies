class Photo < ActiveRecord::Base

  mount_uploader :image, ImageUploader
  serialize :tags, JSON
  validates_presence_of :title, :image

end
