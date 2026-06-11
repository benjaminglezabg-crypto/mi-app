FROM public.ecr.aws/docker/library/python:3.12-slim
WORKDIR /app
COPY . /app
EXPOSE 8000
CMD ["python", "-m", "http.server", "8000"]
