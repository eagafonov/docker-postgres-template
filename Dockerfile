FROM postgres:9.4
MAINTAINER e.a.agafonov@gmail.com

ENV DATABASE_NAME database_template
ENV DBUSER_NAME dbuser
ENV DBUSER_PASSWORD dbusersafepassword


ADD docker-entrypoint-initdb.d/initdb.sh /docker-entrypoint-initdb.d/