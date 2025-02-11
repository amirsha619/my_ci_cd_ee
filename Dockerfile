FROM python:3.11

WORKDIR /app
COPY . .

# Install setuptools to get distutils
RUN pip install --upgrade pip setuptools django==3.2

RUN python3 manage.py migrate

EXPOSE 8000
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
