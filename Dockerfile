#FROM openjdk:11
#EXPOSE 8087
#ADD target/eventsProject-1.0.0.jar eventsProject-1.0.0.jar
#ENTRYPOINT ["java","-jar","/eventsProject-1.0.0.jar"]


FROM openjdk:17-alpine

RUN apk --no-cache add freetype \
    && apk add --no-cache msttcorefonts-installer fontconfig \
    && update-ms-fonts \
    && fc-cache --force

ENV _JAVA_OPTIONS="-Djava.awt.headless=true"

VOLUME /tmp

ARG JAR_FILE
#COPY target/${JAR_FILE} app.jar
COPY target/${JAR_FILE:-app.jar} app.jar


ENTRYPOINT [ "sh", "-c", "java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]