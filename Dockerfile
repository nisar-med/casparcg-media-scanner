FROM node:18 as build
  WORKDIR /usr/src/app

  COPY package.json yarn.lock jest.config.js tsconfig.build.json tsconfig.json ./
  RUN sed -i -e 's/^  "version": "[0-9.]\+",$//' package.json
  COPY ./src ./src

  RUN yarn install && \
      yarn run build:ts

FROM node:18
  COPY --from=build /usr/src/app/dist /usr/src/app/dist
  ENV NODE_ENV production
  ENV PATHS__FFMPEG ffmpeg
  ENV PATHS__FFPROBE ffmpeg
  WORKDIR /usr/src/app
  COPY package.json yarn.lock ./

  RUN yarn install && \
      apt-get update && \
      apt-get install ffmpeg -y

  CMD [ "node", "dist" ]
