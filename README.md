# Turnout

Use facial recognition to automatically keep track of class attendance. Seamless integration with Google Sheets and Canvas -- never manually enter another attendance grade again.

## Installation and Setup

### AWS Configuration

Turnout relies on AWS for it's core features. Export your AWS credentials into bash so that Turnout can access them.

```bash
AWS_SECRET_ACCESS_KEY=<your-secret-key-here>
AWS_ACCESS_KEY_ID=<your-access-key-id-here>
```

### Running the app locally

This webapp is hosted on AWS Elastic Beanstalk. If you'd like to run it locally, please follow these steps:

1. First, install ruby

```bash
brew install ruby
```

2. After cloning the repository, go into it's directory and install the necessary ruby gems.

```bash
bundle install
```

3. Start the web server

```bash
rails server
```

4. The app is now running on `localhost:3000`, go there in Google Chrome or Firefox to test it out!

### App Dependencies

* Ruby v2.6.3
* Rails v4.2.10

## Databases

SQLite3 is used for our development, testing, and prod databases in the Ruby on Rails webapp. 

DynamoDB was also used as a "quick and dirty" datastore so that various Lambda functions could easily fetch the proper URL of the Google Spreadsheet they were to manipulate.

## //TODO: Add Architecture diagram
