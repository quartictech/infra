FROM python:3.6.0-alpine

RUN mkdir /jobs
WORKDIR /jobs
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD *.py .

CMD python registry_cleanup.py
