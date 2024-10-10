# Stage 1: Build the application
FROM maven:3.9.5-openjdk-21 AS builder



# Set the working directory inside the container
WORKDIR /app



# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B



# Copy the rest of the application source code and build the application
COPY src ./src
RUN mvn clean install -DskipTests



# Stage 2: Create the runtime image
FROM openjdk:21


# Set the working directory inside the container
WORKDIR /app



# Copy the built war file from the build stage
COPY --from=builder /app/target/*.war demo.war



# Expose the application port
EXPOSE 9093:8080



# Define the entrypoint to run the application
ENTRYPOINT ["java", "-jar", "demo.war"]
