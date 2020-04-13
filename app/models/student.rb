class Student < ActiveRecord::Base
  belongs_to :classroom, :class_name => "Classroom", :foreign_key => "classroom_id"
end