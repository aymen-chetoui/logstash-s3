# No aws keys are used for ths configurtion. We assume that the right AWS role with the right access policy was attached to the EC2 instance.

# Install docker. Get the latest version :

sudo sh -c "wget -qO- https://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb http://get.docker.io/ubuntu docker main\ > /etc/apt/sources.list.d/docker.list"
sudo aptitude update
sudo aptitude install lxc-docker -y

# Build dokcer image. Example, we will call our image logstashs3.

docker build -t 'logstashs3' .

# Run the docker image. In the example replace 0000 with the port number Logstash will be listening to.
# Change json to the codec of your choice.
# Change the sizefile in bytes and timefile in minutes to the values of your choice. https://www.elastic.co/guide/en/logstash/current/plugins-outputs-s3.html

docker run --expose 0000 \
-p 0000:0000 \
-e INPUT-TCP-CODEC="json" \
-e INPUT-TCP-PORT=0000 \
-e OUTPUT-S3-REGION="aws-region-1" \
-e OUTPUT-S3-BUCKET="S3BucketName" \
-e OUTPUT-S3-SIZEFILE=2048 \
-e OUTPUT-S3-TIMEFILE=1 \
-e OUTPUT-S3-CODEC="json" \
-d logstashs3
