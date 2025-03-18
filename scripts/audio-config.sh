#!/bin/bash

# Путь к файлу
FILE="$HOME/.local/bin/osu"

# Проверяем, существует ли файл
if [[ ! -f "$FILE" ]]; then
  echo "File $FILE does not exist. Please check the path."
  exit 1
fi

# Функция для чтения текущего значения STAGING_AUDIO_PERIOD
read_value() {
  if grep -q "export STAGING_AUDIO_PERIOD=" "$FILE"; then
    CURRENT_VALUE=$(grep "export STAGING_AUDIO_PERIOD=" "$FILE" | cut -d'=' -f2)
    echo "Current value of STAGING_AUDIO_PERIOD: $CURRENT_VALUE"
  else
    echo "Variable STAGING_AUDIO_PERIOD not found in the file."
    read -p "Do you want to create it? (y/n): " create_choice
    if [[ "$create_choice" == "y" ]]; then
      CURRENT_VALUE=6667 # Значение по умолчанию
      echo "export STAGING_AUDIO_PERIOD=$CURRENT_VALUE" >>"$FILE"
      echo "STAGING_AUDIO_PERIOD created with default value 6667."
    else
      echo "Exiting."
      exit 1
    fi
  fi
}

# Отображаем текущее значение
read_value

# Предлагаем установить новое значение
echo "Choose a new value for STAGING_AUDIO_PERIOD:"
echo "1. 3333"
echo "2. 6667"
echo "3. 13333"
read -p "Enter your choice (1/2/3): " choice

# Устанавливаем новое значение в зависимости от выбора
case $choice in
1)
  NEW_VALUE=3333
  ;;
2)
  NEW_VALUE=6667
  ;;
3)
  NEW_VALUE=13333
  ;;
*)
  echo "Invalid choice. Exiting."
  exit 1
  ;;
esac

# Обновляем значение в файле
sed -i "s/export STAGING_AUDIO_PERIOD=.*/export STAGING_AUDIO_PERIOD=$NEW_VALUE/" "$FILE"
echo "STAGING_AUDIO_PERIOD updated to $NEW_VALUE"

# Обновляем STAGING_AUDIO_DURATION в соответствии с новым значением
case $NEW_VALUE in
3333)
  NEW_DURATION=6667
  ;;
6667)
  NEW_DURATION=13333
  ;;
13333)
  NEW_DURATION=26666
  ;;
esac

# Обновляем STAGING_AUDIO_DURATION в файле
if grep -q "export STAGING_AUDIO_DURATION=" "$FILE"; then
  sed -i "s/export STAGING_AUDIO_DURATION=.*/export STAGING_AUDIO_DURATION=$NEW_DURATION/" "$FILE"
else
  echo "export STAGING_AUDIO_DURATION=$NEW_DURATION" >>"$FILE"
fi
echo "STAGING_AUDIO_DURATION updated to $NEW_DURATION"
