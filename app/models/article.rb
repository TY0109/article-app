class Article < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 10}
  validates :content, presence: true
  
  mount_uploader :img, ImgUploader
end
