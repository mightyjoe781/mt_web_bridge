FROM python:latest
WORKDIR /mt_backend
# add requirements file as that is correct practice
COPY . /mt_backend

RUN pip install Flask
EXPOSE 8050
ENTRYPOINT ["python3","-m", "flask", "--app", "server", "run", "--host", "0.0.0.0", "--port", "8050"]