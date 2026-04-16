#!/bin/bash

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите от имени root"
  exit
fi

# Установка зависимостей
apt update && apt install -y curl jq openssl uuid-runtime

# Установка последней версии Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

# Генерация ключей для Reality
KEYS=$(xray x25519)
PRIVATE_KEY=$(echo "$KEYS" | awk '/Private key:/ {print $3}')
PUBLIC_KEY=$(echo "$KEYS" | awk '/Public key:/ {print $3}')
SHORT_ID=$(openssl rand -hex 8)

# Сохранение ключей во временный файл для настройки
echo "PRIVATE_KEY=$PRIVATE_KEY" > /etc/xray/reality.env
echo "PUBLIC_KEY=$PUBLIC_KEY" >> /etc/xray/reality.env
echo "SHORT_ID=$SHORT_ID" >> /etc/xray/reality.env

echo "Установка завершена. Используйте menu.sh для управления."
