# $1 HOST IP
# $2 MySQL IP
# $3 MySQL Port
# $4 MySQL user 
# $5 MySQL password 
# $6 osqa-docker image ID

sudo docker run -d -p $1:49175:22 $2 $3 $4 $5 $6