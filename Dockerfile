FROM cruizba/ubuntu-dind

 ####install jenkins 
RUN apt update 
RUN apt-get install -qy openjdk-8-jdk

RUN useradd -m -s /bin/bash jenkins
RUN echo "jenkins:jenkins" | chpasswd
RUN wget https://get.jenkins.io/war/2.265/jenkins.war 
# RUN wget https://get.jenkins.io/war/2.265/jenkins.war -P /home/jenkins
# USER jenkins

ENTRYPOINT ["startup.sh"]
CMD java -jar jenkins.war
# RUN usermod -aG docker jenkins


# docker run -it --privileged --rm -d -p 8082:8080 --name dind_ubunu jenkinsdocker_ubuntudind:latest

