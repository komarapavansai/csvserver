# The csvserver assignment

Please find the solutions for all the parts (namely Part I ,Part II and Part III) of this assignment in the below sections


## Part I
  1. The motive in the Part is to debug the issue for the container image `infracloudio/csvserver:latest` and fix the issue to bring up the application.Use this command to bring up the container : `docker run infracloudio/csvserver:latest`
  2. After running the container with the given Docker image , one would find that container the in failed state with failure message `error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory` 
  3. Clearly , the application was failed as the file `inputdata` was missing. Therefore ,as stated in the Problem Statement , we need to create a bashscript `gencsv` to generate a file named `inputdata` with content like below:
     ```csv
     0, 234
     1, 98
     2, 34
     ```
  4. Now run the container in the background to add and execute the bash script file to the generate file `inputdata`.
     - Command to run the container in background : `docker run -d infracloudio/csvserver:latest tail -f /dev/null`
     - Once the above command is executed , we will get the containerId of started container.We can also get the containerId for a conrainer by executing the command `docker ps`.
     - After retrieving the containerId , execute into the docker container to add the bash script.Command for executing into the container : `docker exec -it <ContainerId> /bin/bash`.
     - After entering inside the container,add the bash script file.Please refer the bash script file in the directory `Solution/gencsv.sh`. Once it is added ,execute the bash file with command `bash gencsv.sh` .
     - On executing the bash script file ,the file inputdata will be generated.Make sure that the generated file is readable to other users.To ensure this, check the permission of the files using `ls -l` , if not execute this command to make file readable to other user : `chmod o=r inputdata`.
     - On doing all these changes , exit the container and create a docker image with a different tag in your local system to run the container again.Command to create docker image with new tag : `docker commit d578c5773f9c infracloudio/csvserver:add-input-file`
  5. Now run the container with command `docker run -d infracloudio/csvserver:add-input-file /csvserver/csvserver` to know the port on which the application is running.To know the application port , inspect the container to find the port under Config section (with command `docker inspect  <containerId>`). Else we can also find the port in `docker ps` command.After finding the port , stop the container.
  > **NOTE**: While starting a new container ,we need to make sure that we are overriding the command with `/csvserver/csvserver`. Else the application wouldn't be started.
  6. As per the requirement we need to make application accessible on port 9393 and set and environment variable `CSVSERVER_BORDER` to value `Orange`.To achieve this we need to expose port 9090 to port 9393 with `-p` argument in docker run command and similarly use `-e` argument to set environment variable like shown below .Use this command to start the application
     ```sh
     docker run -d -p 9393:9300 -e CSVSERVER_BORDER=Orange infracloudio/csvserver:add-input-file /csvserver/csvserver
     ```

After following all the above mentioned steps ,we could see that application is accessible at http://localhost:9393, with 10 entries from `inputFile` and the welcome note with an orange color border.

## Part II
  0. The objective of this Part is to run application with docker-compose.Make sure to delete the running containers.
  1. Please refer the `docker-compose.yaml` in the repo directory `Solution/docker-compose.yaml` for running application(with the same setup done in Part I) with docker-compose.
  2. After creating the docker-compose.yaml , run the file to bring up the application.
  > **NOTE**:Make sure to run the docker-compose with detached mode by using argument -d.
    ```sh
    docker-compose up -d
     ```

## Part III
   0. In this Part , we need to add a prometheus conatainer as part of docker-compose and run docker-compose to start application and prometheus container. Once both the containers are started , we need to scrape the metrics from applcation.On going further we need to stop the running containers.
   1. Add the prometheus container to docker-compose.yaml file , refer repo directory `solution/docker-compose.yaml`.
   2. To configure prometheus to collect data from application endpoint (localhost:9393/metrics) , we need to create a file called `prometheus.yml` for configuring the scraping.Once the file is created , we need to mount this file to volume directory like this `/root/csvserver/solution:/etc/prometheus` in docker-compose.yaml under volumes section in prmetheus container.Refer `solution/docker-compose.yaml`.
   3. Now bring up the docker-compose by using the command `docker-compose up -d`.
   4. After executing these steps , we could see that prometheus running on port 9090 and on typing `csvserver_records` in query box of Prometheus , it will show a straight line graph with value 10