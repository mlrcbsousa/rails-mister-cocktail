class Ingredient < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :doses

  # before_destroy :check_for_dose_children

  # private

  # def check_for_dose_children
  #   doses
  # end
end
