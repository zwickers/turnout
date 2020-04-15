class UploadsController < ApplicationController
  
  def new
  	flash[:student_id] = params[:student_id]
  	flash[:uni_id] = params[:uni_id]
  	flash.keep
  end

  def create

	s3 = Aws::S3::Resource.new(
	credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),  
	region: 'us-east-1') 

	# the file in the S3 will simply be named the student's university id
	filename = params[:uni_id] + ".jpg"

	obj = s3.bucket('individual-student-faces').object(filename)

	obj.upload_file(params[:file].tempfile ,acl:'public-read')

    # Check if it was successfully uploaded to S3
    if obj.public_url
      student = Student.find_by(id: flash[:student_id])
      student.update(did_upload_photo: true)
      flash[:student_id_to_change] = flash[:student_id]
      redirect_to "/classrooms/#{flash[:classroom_id]}", success: 'File successfully uploaded'
    else
      flash.now[:image_upload_error] = 'There was an error uploading the image. Please try again later.'
      redirect_to "/classrooms/#{flash[:classroom_id]}"
    end
  end

  def index
  end
end