FROM python:3-alpine
# Based on tiangolo/uvicorn-gunicorn-fastapi:python3.7

LABEL maintainer="Konstantin Cherednichenko <dshadowukraine@gmail.com>"

# Installing base packages
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make \
    && pip install --no-cache-dir -r uvicorn gunicorn fastapi \
    && apk del .build-deps gcc libc-dev make

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

COPY ./gunicorn_conf.py /gunicorn_conf.py

COPY ./start-reload.sh /start-reload.sh
RUN chmod +x /start-reload.sh

COPY ./app /app
WORKDIR /app/

ENV PYTHONPATH=/app

EXPOSE 3000

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Gunicorn with Uvicorn
CMD ["/start.sh"]
