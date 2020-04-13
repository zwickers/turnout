class Classroom < ActiveRecord::Base
	belongs_to :user, :class_name => "User", :foreign_key => "prof_id"
	has_many :students, :class_name => "Student", :foreign_key => "classroom_id"
end