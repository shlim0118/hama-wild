FROM openjdk:17
ADD . /wild
WORKDIR /wild
ENTRYPOINT ["java","-jar","paper-1.20.2-318.jar","--nogui"]
