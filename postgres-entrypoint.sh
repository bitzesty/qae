#!/bin/bash
set -e

# Check if the database is in recovery mode
if pg_isready; then
  echo "Database is ready"
else
  echo "Database is in recovery mode or not ready. Attempting to recover..."
  # You might need to adjust this path depending on your PostgreSQL version and setup
  rm -f /var/lib/postgresql/data/postmaster.pid
fi

# Run the main entrypoint
exec docker-entrypoint.sh "$@"
