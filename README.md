# Jenkins-dockerdind

## To run Jenkins server on docker-dind, run the following command:

```
docker run -d -it \
--name jenkins-dind \
--restart=always \
-v jenkinsdocker_ubuntudind:/root/.jenkins \
-p 8080:8080 --privileged \
yossie17/jenkinsdocker_ubuntudind:v3
```
