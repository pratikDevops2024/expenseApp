HEADING() {
  echo -e "\e[35m$*\e[0m" # Magenta color for the content
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSuccess\e[0m"  # Green color for Success
  else
    echo -e "\e[31mFailure\e[0m"  # Red color for Failure
    exit 2
  fi
}