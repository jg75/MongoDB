FROM mongo:4

ENV PATH=$PATH:/usr/src/app:.
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . .

RUN mv entrypoint.sh / && chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
