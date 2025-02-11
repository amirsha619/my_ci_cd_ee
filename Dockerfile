FROM python:3.11-slim

WORKDIR /app
# Copy only required files
COPY ./requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools django==3.2

# Then copy the rest of the app
COPY . .

# Run migrations (if needed)
RUN python3 manage.py migrate || echo "Skipping migrations"

EXPOSE 8000

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]