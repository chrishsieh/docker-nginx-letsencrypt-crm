FROM neilpang/nginx-proxy:alpine

RUN apk add --update jq

COPY ./presetup /app
COPY ./Procfile /app
RUN chmod +x /app/presetup

EXPOSE 3306
