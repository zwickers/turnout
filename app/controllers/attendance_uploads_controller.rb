class AttendanceUploadsController < ApplicationController
  
  def create
  	s3 = Aws::S3::Resource.new(
  	credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),  
  	region: 'us-east-1') 

  	# the file in the S3 will simply be named prof_email/class_id/date.jpg
  	filename = "#{current_user.email}/#{params[:classroom_id]}/#{params[:date]}.jpg"

  	obj = s3.bucket('attendance-turnout-dev').object(filename)

  	obj.upload_file(params[:file].tempfile ,acl:'public-read')

    # Check if it was successfully uploaded to S3
    if obj.public_url
      # TODO: add a record in db for this so we can display all the attendance pictures that have been uploaded
      flash[:attendance_image_success] = "Image uploaded successfully! You'll recieve an email once the attendance grades have been entered on your Google Sheet"
      redirect_to "/classrooms/#{params[:classroom_id]}"
    else
      flash[:attendance_image_error] = 'There was an error uploading the image. Please try again later.'
      redirect_to "/classrooms/#{params[:classroom_id]}"
    end
  end

  def index
  end
end