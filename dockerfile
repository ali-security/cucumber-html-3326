# Use an older Ubuntu base to ensure compatibility with 2012-era binaries
FROM ubuntu:16.04

# Install build dependencies (python and build-essential are often needed for old npm modules)
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    python \
    git \
    && rm -rf /var/lib/apt/lists/*

# Download and install Node.js v0.8.28 (the final release of the 0.8 line)
RUN curl -k -O https://nodejs.org/dist/v0.8.28/node-v0.8.28-linux-x64.tar.gz \
    && tar -xzf node-v0.8.28-linux-x64.tar.gz -C /usr/local --strip-components=1 \
    && rm node-v0.8.28-linux-x64.tar.gz

# Verify installation
RUN node -v && npm -v

RUN apt-get update && apt-get install -y maven

RUN git clone --branch v0.2.6 https://github.com/cucumber-attic/cucumber-html.git && \
    cd cucumber-html

# Force NPM to use HTTP (fixes SSL errors on Node 0.8)
RUN npm config set registry http://registry.npmjs.org/

# Install the Node.js dependencies
RUN npm Install

# RUN sed -i 's/\/bin\/false/\/bin\/true/g' Makefile
# Run the default make task with a fake GPG agent variable
# RUN GPG_AGENT_INFO=dummy make

# Package the project into a JAR without signing or releasing it
RUN mvn clean install

# Set up the working directory
WORKDIR /app
CMD ["bash"]