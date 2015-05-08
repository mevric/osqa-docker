#Command to stop all docker containers
docker ps -aq | xargs --no-run-if-empty sudo docker stop

#Command to remove all docker containers
docker ps -aq | xargs --no-run-if-empty sudo docker rm

#Command to remove all docker images. Think twice before using this.
#sudo docker images -q | awk '{print $1}' | xargs --no-run-if-empty sudo docker rmi

#Command to remove dangling docker images. Avoid executing this while a docker build is running. 
docker images -f 'dangling=true' -q | awk '{print $1}' | xargs --no-run-if-empty sudo docker rmi