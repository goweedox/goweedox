class Documentation < ActiveRecord::Base
	belongs_to :user
	has_many  :screenies
end
