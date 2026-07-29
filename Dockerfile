# Maven build container 
FROM public.ecr.aws/docker/library/maven:3.9.14-eclipse-temurin-17 AS maven_build
COPY pom.xml /tmp/ 
COPY src /tmp/src/ 
WORKDIR /tmp/ 
# Skip tests to guarantee a smooth cloud compilation
RUN mvn package -DskipTests

# Pull base image 
FROM public.ecr.aws/docker/library/eclipse-temurin:17 
MAINTAINER dstar55@yahoo.com 

# Expose port 8080 
EXPOSE 8080 

# FIX: Uses a wildcard to grab your war file, renaming it to app.war safely
COPY --from=maven_build /tmp/target/*.war /data/app.war 

# FIX: Run the statically named app file with stable entrypoint array syntax
ENTRYPOINT ["java", "-jar", "/data/app.war"]

LABEL version="1.1"
