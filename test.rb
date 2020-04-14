require 'aws-sdk-s3'

s3 = Aws::S3::Resource.new(
 credentials: Aws::Credentials.new('AKIA3IE4MLGKI2OPKP4J', 'ckVMzaNHq8qCF/eqQYMipSUin6QLR2tjtqzCBuFa'),  
region: 'us-east-1') 

obj = s3.bucket('turnout-test-bucket').object('test.jpg')

obj.upload_file('/Users/justinzwick/Desktop/turnout/app/assets/images/person_facial_recognition.jpg',acl:'public-read')
