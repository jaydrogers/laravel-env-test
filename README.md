# Example App For Testing Laravel ENVs with "serversideup/php" Docker Images
This is an example repo for troubleshooting ENV behavior with Laravel + Docker.

### 🎥 Watch the video
If you want to watch the video going over this test, view this link: https://www.dropbox.com/s/t2oucxf6mxxxi9r/LaravelEnvTest.mp4?dl=0

## Running via Docker Compose
Follow these steps to test this on your local machine.

### 1. Configure `.env`
Copy over `.env.example` → `.env`
```bash
cp .env.example .env
```

### 2. Bring up containers
```bash
./vendor/bin/spin up
```

### 3. Run migrations
```bash
./vendor/bin/spin exec php php artisan migrate
```

### 👉 EXPECTED RESULT: Migrations should Run
You should see something like:
```txt
2014_10_12_000000_create_users_table ......................................................... 8ms DONE
2014_10_12_100000_create_password_resets_table ............................................... 8ms DONE
2019_08_19_000000_create_failed_jobs_table .................................................. 10ms DONE
```

## Running as a compiled docker image (with "docker run")
To test a compiled image.

### 1. Configure `.env`
Copy over `.env.example` → `.env`

### 2. Build docker image
```bash
docker build -t localhost/laravel-env-test-php .
```

### 3. Create a docker network
```bash
docker network create laravel-env-test-network
```

### 4. Bring up a test MariaDB container
```bash
docker run --rm \
	--name=mariadb \
	--network=laravel-env-test-network \
	-e MYSQL_ROOT_PASSWORD="rootpassword" \
	-e MARIADB_DATABASE="laravel" \
	-e MARIADB_USER="example-app-user" \
	-e MARIADB_PASSWORD="example-app-password" \
	mariadb:10.7
```
### 3. Run the docker image (with environment variables)
```bash
docker run --rm \
	--name=laravel-env-test-php \
	--network=laravel-env-test-network \
	-p 80:80 \
	-p 443:443 \
	-e DB_CONNECTION=mysql \
	-e DB_HOST=mariadb \
	-e DB_PORT=3306 \
	-e DB_DATABASE=laravel \
	-e DB_USERNAME=example-app-user \
	-e DB_PASSWORD=example-app-password \
	-e AUTORUN_LARAVEL_MIGRATION=true \
	localhost/laravel-env-test-php
```

### 4. Run the migrations
```bash
docker exec laravel-env-test-php php artisan migrate
```

### 👉 EXPECTED RESULT: Migrations should Run
You should see something like:
```txt
2014_10_12_000000_create_users_table ......................................................... 8ms DONE
2014_10_12_100000_create_password_resets_table ............................................... 8ms DONE
2019_08_19_000000_create_failed_jobs_table .................................................. 10ms DONE
```