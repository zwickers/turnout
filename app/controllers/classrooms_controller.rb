class ClassroomsController < ApplicationController
	# id
	# name
	# prof_id
	def index
		@classrooms = Classroom.where(prof_id: current_user.id)
	end

	# GET /classrooms/new
	def new

	end

	# POST /classrooms
	def create
		class_name = params[:class_name]
		Classroom.create(name: class_name, prof_id: current_user.id)
		redirect_to "/classrooms"
	end

	# GET /classroom/id
	def show
		@classroom = Classroom.find(params[:id])
	end
end
