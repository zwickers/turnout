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
		# create the Lambda client we use to invoke the Lambda function.
		client = Aws::Lambda::Client.new(region: 'us-east-1')
		req_payload = {:prof_email => current_user.email, :class_name => class_name}
		payload = JSON.generate(req_payload)
		resp = client.invoke({
                         function_name: 'create_google_spreadsheet_for_class',
                         invocation_type: 'RequestResponse',
                         log_type: 'None',
                         payload: payload
                       })
		resp_payload = JSON.parse(resp.payload.string) 
		
		# If the status code is 200, the call succeeded
		if resp_payload["statusCode"] == 200
		  body = JSON.parse(resp_payload["body"])
		  url = body["spreadsheet_url"]
		  new_class = Classroom.create(name: class_name, prof_id: current_user.id, url: url)
		  # now that we have an id for the classroom, let's map
		  # it to the sheet url in a dynamodb table, so we can
		  # fetch the url in other lambda functions
		  req_payload = {:prof_email => current_user.email, classroom_id: new_class.id, url: url}
		  payload = JSON.generate(req_payload)
		  client.invoke({
                         function_name: 'write_spreadsheet_url_to_db_table',
                         invocation_type: 'RequestResponse',
                         log_type: 'None',
                         payload: payload
                       })
		  redirect_to "/classrooms"
		end
	end

	# GET /classroom/id
	def show
		@classroom = Classroom.find(params[:id])
		flash[:classroom_id] = @classroom.id
		@students = Student.where(classroom_id: @classroom.id)
		@attendance_uploads = AttendanceUpload.where(prof_id: current_user.id, classroom_id: @classroom.id)
		flash[:url] = @classroom.url
	end

	def destroy
		Classroom.delete(params[:id])
		redirect_to "/classrooms"
	end
end
