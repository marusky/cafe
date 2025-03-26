class Product < ApplicationRecord
  MINIMAL_PRICE = 1
  THUMBNAIL_DIMENSION = 96 * 3

  belongs_to :category

  has_one_attached :image do |image|
    image.variant :thumbnail, resize_to_fill: [THUMBNAIL_DIMENSION, THUMBNAIL_DIMENSION], preprocessed: true
    image.variant :modal, resize_to_fill: [900, 600], preprocessed: true
  end

  validates :title, presence: true
  validates :price, numericality: { 
    only_integer: true, greater_than_or_equal_to: MINIMAL_PRICE 
  }

  scope :available, -> { where(is_available: true) }
end
