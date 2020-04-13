class StudentsController < ApplicationController

	# GET /students/new
	def new
		
	end

	# POST /studnets
	def create
		classroom_id = params[:classroom_id]
		university_id = params[:university_id]
		student_name = params[:student_name]
		Student.create(name: student_name, university_id: university_id, did_upload_photo: false, classroom_id: classroom_id)
		redirect_to "/classrooms/#{classroom_id}"
	end

end
