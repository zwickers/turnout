class Classroom < ActiveRecord::Base
	belongs_to :user, :class_name => "User", :foreign_key => "prof_id"
end