class Menu < ApplicationRecord
  belongs_to :recipe
  belongs_to :meal
end
