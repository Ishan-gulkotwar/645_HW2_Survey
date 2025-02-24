# SWE645 - Assignment 1 
# Name - Ishan Gulkotwar
# G01390426

## Project Overview
This repository contains the implementation of a Student Survey Form along with a homepage, created as part of SWE645 Assignment 1. The application is hosted using AWS services (S3 and EC2).

## Project URLs
- Homepage (S3): http://swe-645-homepage.s3-website.ap-south-1.amazonaws.com/
- Survey Form (EC2): http://ec2-13-232-191-169.ap-south-1.compute.amazonaws.com/survey.html

## Project Overview
This project implements a student survey system with two main components:
1. A homepage hosted on AWS S3
2. A student survey form hosted on AWS EC2

## Configuration Steps

### Part 1: AWS S3 Configuration (Homepage)
1. Create S3 Bucket
   - Sign in to AWS Console
   - Navigate to S3 service
   - Create bucket named "swe-645-homepage"
   - Region: Asia Pacific (Mumbai)
   - Uncheck "Block all public access"

2. Enable Static Website Hosting
   - Select bucket → Properties
   - Static website hosting → Enable
   - Index document: index.html
   - Error document: error.html

3. Configure Bucket Policy

json ->
{
    "Version": "2012-10-17",
    "Statement" : [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::swe-645-homepage/*"
        }
    ]
}

4. Upload Files
- Upload index.html and error.html
- Verify public accessibility

## PART 2: AWS EC2 Configuration (Survey Form)

# 1. Launch EC2 Instance
  - Name: swe-645-survey-final
  - AMI: Amazon Linux 2023
  - Instance type: t2.micro
  - Create key pair (swe-645-final-key.pem)
  - Configure Security Group: 
    - Allow SSH (Port 22)
    - Allow HTTP (Port 80)
    - Allow HTTPS (Port 443)

# 2. Install and Configure Apache

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start sttpd
sudo systemctl enable httpd

# 3. Deploy Survey Form

cd /var/www/html
sudo nano survey.html
sudo chmod 664 survey.html
sudo chown apache:apache survey.html

## Project Components
1. Homepage (index.html)
 - Responsive W3.CSS design with parallax effect
 - Navigation menu
 - Links to survey form
 - About Section
 - Footer with social links

2. Error Page (error.html)
 - Custom 404 error handling
 - Consistent theme with homepage
 - Return with homepage link

3. Survey Form (survey.html)
- Required Fields 
 - Personal Information 
  - First Name
  - Last Name
  - Street Address
  - City 
  - State
  - ZIP
  - Telephone
  - Email
  - Date of Survey

- Additional Features
 - Campus Feature Chechboxes:
  - Friends 
  - Television 
  - Internet
  - Other

- Recommendation Dropdown
  - Raffle Number Input
  - Comments Section 
  - Submit/Cancel Buttons

  ## Technologies Used

  - HTML5
  - CSS (W3.CSS Framework)
  - AWS S3 (Static Website Hosting)
  - AWS EC2 (Apache Web Server)
  - Amazon Linux 2023

## Project Structure

AWS_Assignment_1_645
C:.
│   README.md
│
├───EC2_files
│       survey.html
│
└───S3_Files
        error.html
        index.html
    
## Implementation Features

 - Mobile-Responsive Design
 - Form Validation Implementation
 - Error Handling
 - Cross-Browser Compatibility

## Submitted Files
- index.html (Homepage)
- error.html (Error Page)
- survey.html (Survey Form)
- README.md (Documentation)


