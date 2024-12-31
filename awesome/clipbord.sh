
#!/usr/bin/env sh


#!/bin/bash

#!/bin/bash


case "$1" in
  "S")
      copyq &  # Start CopyQ in the background
    ;;
  "C")
      copyq clean  # Clean the CopyQ clipboard history
    ;;
  "L")
      copyq list  # List all items in CopyQ
    ;;
  *)
    echo "Invalid selection. Please enter 'S', 'C', or 'L'."
    ;;
esac
