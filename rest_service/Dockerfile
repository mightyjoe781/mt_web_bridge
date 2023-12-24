FROM python:latest
COPY server.py app/
WORKDIR /app
RUN pip install Flask
EXPOSE 8050
ENTRYPOINT ["python3","-m", "flask", "--app", "server", "run", "--host", "0.0.0.0", "--port", "8050"]