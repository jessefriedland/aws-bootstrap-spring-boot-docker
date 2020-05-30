FROM openjdk:11.0-jdk
RUN groupadd bootstrap && useradd bootstrap -g bootstrap
USER bootstrap:bootstrap
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
