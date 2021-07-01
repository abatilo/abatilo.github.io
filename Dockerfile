FROM klakegg/hugo:0.84.4 as builder

WORKDIR /src
COPY config.toml ./
COPY content ./content
COPY layouts ./layouts
COPY static ./static
COPY themes ./themes
RUN hugo --minify

FROM nginx:1.21.0-alpine

COPY --from=builder /src/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
