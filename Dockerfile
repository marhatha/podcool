FROM python:3-alpine

LABEL AUTHOR="William Caban"
LABEL APP="podcool"

ENV APP_VERSION v2-dockerfile
ENV APP_MESSAGE "Docker build default message"

WORKDIR /usr/src/app
ENV APP_CONFIG=/usr/src/app/config.py

COPY requirements.txt ./

# NOTE: Not upgrading packages to demo security scanner
# detecting vulnerabilities (if exist)
#RUN apk update && apk upgrade 

# These packages are required for pip with the alpine image
RUN apk add py-configobj libusb py-pip python-dev gcc linux-headers libc-dev

RUN pip install --no-cache-dir -r requirements.txt

# Including Dockerfile in final image for documentation
ADD Dockerfile config.py wsgi.py tcpping.py ./
ADD static ./static/
ADD templates ./templates/

# Using same port used by s2i source strategy
EXPOSE 8080

# Forcing to run as non-root user
USER 10001

CMD [ "gunicorn", "wsgi:app","-b","0.0.0.0:8080" ]

#
# END OF FILE
#
