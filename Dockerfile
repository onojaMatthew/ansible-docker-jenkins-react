FROM node:alpine AS module-install-stage
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json /app/package.json
RUN npm install
FROM node:alpine AS build-stage
COPY --from=module-install-stage /app/node_modules/ /app/node_modules
WORKDIR /app
COPY . .

RUN npm run build
FROM node:alpine
COPY --from=build-stage /app/build/ /app/build
RUN npm install -g serve
CMD serve -s /app/build -l 3000