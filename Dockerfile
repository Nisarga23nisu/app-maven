# Use an official Maven image to build the project
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file (pom.xml) and install dependencies
COPY pom.xml .

# Copy the rest of the application files
COPY src ./src

# Run Maven to build the project and create the .jar file
RUN mvn clean package

# Now, create the runtime image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the generated jar file from the build image to the runtime image
COPY --from=build /app/target/*.jar app.jar

# Expose the port that the app will run on
EXPOSE 8080

# Define the entry point to run the jar file
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
