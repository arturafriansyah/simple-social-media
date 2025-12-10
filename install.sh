#!/bin/sh
set -e

npm config set registry https://registry.npmjs.org/
npm config set fetch-retries 5
npm config set fetch-retry-factor 2
npm config set fetch-timeout 120000        # 120 detik
npm config set fetch-retry-maxtimeout 300000  # 300 detik (5 menit)

npm config delete proxy || true
npm config delete https-proxy || true

composer install --no-dev --optimize-autoloader

npm install --legacy-peer-deps --no-audit --progress=false

npm run dev

cp .env.example .env || true

php artisan key:generate

# Update konfigurasi database
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=172.17.0.1/g' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env

php artisan migrate --force
php artisan db:seed --force
