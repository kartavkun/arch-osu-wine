#!/bin/bash

# Определяем текущую оболочку
SHELL_NAME=$(basename "$SHELL")

# Полный путь к директории osu!
FULL_PATH="$(eval echo ~$USER)/osu!"

# Функция для проверки, существует ли переменная в файле
check_if_exists() {
  local file="$1"
  local search_string="$2"
  if grep -Fxq "$search_string" "$file"; then
    echo "Переменная уже существует в файле: $file"
    return 0
  else
    return 1
  fi
}

# Добавляем строку в зависимости от оболочки
case "$SHELL_NAME" in
bash)
  CONFIG_FILE=~/.bashrc
  EXPORT_STRING="export TOSU_OSU_PATH=\"$FULL_PATH\""
  ;;
zsh)
  CONFIG_FILE=~/.zshrc
  EXPORT_STRING="export TOSU_OSU_PATH=\"$FULL_PATH\""
  ;;
fish)
  CONFIG_FILE=~/.config/fish/config.fish
  EXPORT_STRING="set -x TOSU_OSU_PATH \"$FULL_PATH\""
  ;;
*)
  echo "Оболочка не поддерживается: $SHELL_NAME"
  exit 1
  ;;
esac

# Проверяем, существует ли переменная в файле
if check_if_exists "$CONFIG_FILE" "$EXPORT_STRING"; then
  echo "Ничего не добавлено, переменная уже настроена."
else
  echo "$EXPORT_STRING" >>"$CONFIG_FILE"
  echo "Строка добавлена в конфигурационный файл: $CONFIG_FILE"
fi
