# Filename: Dockerfile 
FROM node:8.12.0
WORKDIR /mid-term-project/mern/
COPY . .
RUN yarn install
EXPOSE 5000
CMD ["yarn", "server"]