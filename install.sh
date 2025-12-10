#!/bin/sh
set -e

# Install dependency composer
composer install --no-dev --optimize-autoloader

# Install dependency Node.js
npm install --legacy-peer-deps

# Build asset Laravel Mix untuk production
npm run dev

# Setup file environment
cp .env.example .env

php artisan key:generate

# Update konfigurasi database
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=172.17.0.1/g' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env

php artisan migrate
php artisan db:seed
