class Category < ActiveRecord::Base

  has_many :topic_category_ships
  has_many :topics , :through => :topic_category_ships

end
