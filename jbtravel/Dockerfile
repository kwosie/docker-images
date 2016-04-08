FROM postgres:9.4

COPY db/structure.sql /docker-entrypoint-initdb.d/

ENV POSTGRES_PASSWORD=postgres