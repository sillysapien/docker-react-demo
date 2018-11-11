FROM node:alpine as builder
WORKDIR /app
COPY package.json .
RUN npm install

# No need for volumes in production
COPY . . 

# Build folder will be in working dir /app/build 
# we need above in run phase
RUN npm run build 

# No tag here. Last block.
# Every FROM represents new block
FROM nginx 

# we want to copy something from builder phase.
# See docs in nginx (hosting simple static content https://hub.docker.com/_/nginx/)
# Some Nginx configuration knowledge
COPY --from=builder /app/build /usr/share/nginx/html

# Defult Command for Nginx container spins up Nginx, so no need for CMD step

# docker build . (no need for -f for production as filename follows convention Dockerfile)
# See logs, multi steps going on. 
# Start it up (80 is default port used by nginx)
# Docker run -p 8080:80 (just hit the site from now on and see logs)
# Just by docker attach container_id (nginx is main process here)

# Why not docker-compose up here? not recommended for production?