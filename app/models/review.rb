class Review < ApplicationRecord
  belongs_to :cocktail
  validates :content, :rating, presence: true
  validates :rating, numericality: true, inclusion: { in: [0, 1, 2, 3, 4, 5] }
end
