FROM python:3.6.0-alpine

WORKDIR /jobs
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD *.py .

CMD python registry_cleanup.py
