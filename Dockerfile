FROM node:20-bookworm-slim

WORKDIR /app

ENV NODE_ENV=production
ENV LANG=C.UTF-8
ENV TZ=Asia/Shanghai
ENV HTTP_PORT=3000
ENV DISABLE_REPL=1

COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund

COPY . .

RUN mkdir -p /app/log /app/config /app/data /app/docker/defaults \
    && cp /app/config/config.json /app/docker/defaults/config.json \
    && cp /app/data/list.json /app/docker/defaults/list.json \
    && chmod +x /app/docker/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/app/docker/entrypoint.sh"]
CMD ["npm", "run", "start:docker"]
