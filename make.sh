#!/bin/bash

# Function to initialize the Django project (migrate)
init() {
  if ! command -v uv &> /dev/null; then
      echo "uv is not installed. Installing uv..."
      curl -LsSf https://astral.sh/uv/0.5.1/install.sh | sh
      if [ $? -ne 0 ]; then
        echo "Failed to install uv. Please check your environment and try again."
        exit 1
      fi
      echo "uv installed successfully."
    else
      echo "uv is already installed."
    fi

  echo "Initializing project..."
  export DJANGO_SUPERUSER_PASSWORD=root
  uv run python manage.py migrate
  uv run python manage.py createsuperuser --noinput --username root --email philipp-lein@devboostiarchitecture.bla || echo "Superuser already exists or creation failed."
  runserver
}

# Function to start the Django server
runserver() {
  echo "Starting Django development server..."
  uv run python manage.py runserver
}

# Main logic to handle the input arguments
if [ "$1" == "init" ]; then
  init
elif [ "$1" == "runserver" ]; then
  runserver
else
  echo "Usage: .make.sh {init|runserver}"
  exit 1
fi
