
#!/bin/python3

from libqtile import qtile

# Get the focused screen
focused_screen = qtile.current_screen

# Monitor details
scale_factor = focused_screen.dpi / 96  # Assuming DPI is available and 96 is the base DPI
monitor_height = focused_screen.height  # Get screen height

# Calculate icon size
icon_size = (monitor_height * 3) / (scale_factor * 150)

# Apply limit
adjusted_icon_size = max(20, min(icon_size, 25))

print(f"Focused Monitor: {focused_screen}")
print(f"Scale Factor: {scale_factor}")
print(f"Monitor Height: {monitor_height}")
print(f"Adjusted Icon Size: {adjusted_icon_size}")
