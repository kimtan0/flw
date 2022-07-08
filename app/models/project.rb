class Project < ApplicationRecord
  has_one_attached :avatar
  acts_as_taggable_on :category
  acts_as_taggable_on :detailed_category


  def avatar_path
    ActiveStorage::Blob.service.path_for(avatar.key)
  end
end
