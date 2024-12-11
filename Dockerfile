FROM openjdk:11
EXPOSE 8087
ADD target/eventsProject-1.0.0-SNAPSHOT.jar eventsProject-1.0.0-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/eventsProject-1.0.0-SNAPSHOT.jar"]