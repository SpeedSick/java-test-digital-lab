FROM openjdk:8-jdk-alpine

RUN mkdir /src

WORKDIR /src

COPY test_input .
COPY Main.java .
RUN javac Main.java

CMD ["java", "-classpath", ".", "Main"]
