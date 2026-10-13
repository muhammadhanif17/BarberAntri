FROM node:20-alpine
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY src ./src
COPY ../shared ../../shared
ENV QUEUE_PORT=3003
EXPOSE 3003
CMD ["node", "src/index.js"]
