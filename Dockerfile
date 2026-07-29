# Maven build container 

FROM public.ecr.aws/docker/library/maven:3.9.14-eclipse-temurin-17 AS maven_build

COPY pom.xml /tmp/

COPY src /tmp/src/

WORKDIR /tmp/

RUN mvn package

#pull base image

FROM public.ecr.aws/docker/library/eclipse-temurin:17

#maintainer 
MAINTAINER dstar55@yahoo.com
#expose port 8080
EXPOSE 8080

COPY --from=maven_build /tmp/target/hello-world-0.1.0.jar /data/hello-world-0.1.0.jar

#default command
CMD java -jar /data/hello-world-0.1.0.jar

#copy hello world to docker image from builder image

LABEL version="1.1"