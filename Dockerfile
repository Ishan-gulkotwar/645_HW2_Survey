FROM tomcat:9.0-jdk15
COPY ./EC2_files/survey.html /usr/local/tomcat/webapps/StudentSurvey/
COPY ./S3_Files/index.html /usr/local/tomcat/webapps/StudentSurvey/
COPY ./S3_Files/error.html /usr/local/tomcat/webapps/StudentSurvey/