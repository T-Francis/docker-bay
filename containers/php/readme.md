# Stargate-laravel

# Project Setup

todo=> project setup details

## Base modification

- Dockerfile tweak
```plaintext
php7.1-soap
```

- docker-compose.yml tweak
```plaintext
re-worked per environement
```

## Installation

- Install laravel
```bash
#connect to the container
composer create-project --prefer-dist laravel/laravel .
```

sudo chown www-data:www-data path/to/application/storage/logs/*