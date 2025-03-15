class Product < ApplicationRecord
  MINIMAL_PRICE = 1
  IMAGE_DIMENSION = 96 * 3

  belongs_to :category

  has_one_attached :image do |image|
    image.variant :thumbnail, resize_to_fill: [IMAGE_DIMENSION, IMAGE_DIMENSION], preprocessed: true
  end

  validates :title, presence: true
  validates :price, numericality: { 
    only_integer: true, greater_than_or_equal_to: MINIMAL_PRICE 
  }
end
