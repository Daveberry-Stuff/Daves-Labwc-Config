#!/bin/sh

echo "Select keybinds to view:"
select choice in "LabWC" "Ranger" "Quit"; do
  case "$choice" in
    LabWC)
      less ~/.config/labwc/keybinds.txt
      break
      ;;
    Ranger)
      less ~/.config/ranger/shortcut-commands.txt
      break
      ;;
    Quit)
      exit 0
      ;;
    *)
      echo "Invalid selection"
      ;;
  esac
done
