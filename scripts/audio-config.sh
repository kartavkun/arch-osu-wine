#!/bin/bash

# Показываем текущие значения буфера
echo "Current pipewire buffer size:"
echo "pipewire.conf:"
sed -n '43p;45p;46p' ~/.config/pipewire/pipewire.conf
echo ""
echo "pipewire-pulse.conf:"
sed -n '73p;105p;106p;107p;110p' ~/.config/pipewire/pipewire-pulse.conf

# Запрашиваем новое значение буфера
read -p "Enter new buffer size (e.g., 128): " new_buffer_size

# Проверяем, что введено число
if ! [[ "$new_buffer_size" =~ ^[0-9]+$ ]]; then
  echo "Error: Please enter a valid number."
  exit 1
fi

# Обновляем pipewire.conf
sed -i '43s/=[[:space:]]*[0-9]\+/='"$new_buffer_size"'/; 45s/=[[:space:]]*[0-9]\+/='"$new_buffer_size"'/; 46s/=[[:space:]]*[0-9]\+/='"$new_buffer_size"'/' ~/.config/pipewire/pipewire.conf

# Обновляем pipewire-pulse.conf
sed -i '73s/=[[:space:]]*[0-9]\+/='"$new_buffer_size"'/; 105s/=[[:space:]]*[0-9]\+/='"$new_buffer_size"'/; 106s/=[[:space:]]*[0-9]\+/='"$new_buffer_size"'/; 107s/=[[:space:]]*[0-9]\+/='"$new_buffer_size"'/; 110s/=[[:space:]]*[0-9]\+/='"$new_buffer_size"'/' ~/.config/pipewire/pipewire-pulse.conf

# Показываем обновлённые значения
echo ""
echo "Updated pipewire buffer size:"
echo "pipewire.conf:"
sed -n '43p;45p;46p' ~/.config/pipewire/pipewire.conf
echo ""
echo "pipewire-pulse.conf:"
sed -n '73p;105p;106p;107p;110p' ~/.config/pipewire/pipewire-pulse.conf

systemctl --user restart pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket

echo "Buffer size updated to $new_buffer_size successfully!"
