#!/bin/bash

sudo pacman -S --needed wine
OSU_PATH="$HOME/osu"
TMP_DIR="$HOME/.tmp"
OSU_HANDLER_FIX_PATH="$HOME/osuinstall/files/osu-handler"
REG_TEMPLATE="$OSU_HANDLER_FIX_PATH/example.reg"
REG_OUTPUT="$TMP_DIR/mount.reg"

# Создаём временную папку, если её нет
mkdir -p "$TMP_DIR"

# Проверяем, существует ли папка osu
if [ ! -d "$OSU_PATH" ]; then
  echo "Ошибка: Папка $OSU_PATH не существует!"
  exit 1
fi

# Преобразуем путь в HEX без лишней запятой перед 00
HEX_PATH=$(echo -n "$OSU_PATH" | od -A n -t x1 | tr -d ' \n' | sed 's/\(..\)/\1,/g' | sed 's/,$//')
HEX_PATH="$HEX_PATH,00"

# echo "Путь в HEX: $HEX_PATH"

# Копируем шаблонный reg-файл в ~/.tmp
cp "$REG_TEMPLATE" "$REG_OUTPUT"

# Делаем замену хекса в файле
iconv -f utf-16 -t utf-8 "$HOME/.tmp/mount.reg" | sed 's/path/2f,68,6f,6d,65,2f,6b,61,72,74,61,76,6b,75,6e,2f,6f,73,75,00/' | iconv -f utf-8 -t utf-16 >"$HOME/.tmp/mount.reg.new"
mv "$HOME/.tmp/mount.reg.new" "$HOME/.tmp/mount.reg"

WINEPREFIX=$HOME/.local/share/wineprefixes/osu-wineprefix wine regedit /s $REG_OUTPUT
WINEPREFIX=$HOME/.local/share/wineprefixes/osu-wineprefix wine regedit /s $OSU_HANDLER_FIX_PATH/osu.reg

sudo cp $OSU_HANDLER_FIX_PATH/osu-file-extensions-handler.desktop /usr/share/applications/osu-file-extensions-handler.desktop

# echo "Файл $REG_OUTPUT успешно создан с заменённым HEX!"
