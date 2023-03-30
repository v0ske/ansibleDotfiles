#!/bin/bash

# Grab a count of how many audio sinks we have
sink_count=$(pactl list sinks | grep -c "Name:")

# Create an array of the actual sink names
sinks=()
mapfile -t sinks < <(pactl list sinks | grep 'Name:' | sed -n -e 's/.*Name:[[:space:]]\([^\"]*\).*/\1/p')

# Get the name of the active sink
active_sink=$(pactl info | awk '/Default Sink:/ {print $NF}')

# Get the name of the last sink in the array
final_sink=${sinks[$((sink_count - 1 ))]}
echo $sinks
echo $final_sink
# Find the index of the active sink
for index in "${!sinks[@]}"; do
  if [[ "${sinks[$index]}" == "$active_sink" ]]; then
    active_sink_index=$index
  fi
done

# Default to the first sink in the list
next_sink=${sinks[0]}
next_sink_index=0

# If we're not at the end of the list, move up the list
if [[ "$active_sink" != "$final_sink" ]] ; then
  next_sink_index=$(( active_sink_index + 1))
  next_sink=${sinks[$next_sink_index]}
fi

# Change the default sink
pactl set-default-sink ${next_sink}

# Move all inputs to the new sink
for app in $(pactl list sink-inputs | grep -oP '(?<=Sink Input #)\d+'); do
  pactl move-sink-input $app $next_sink
done

# Create a list of the sink descriptions
sink_descriptions=()
mapfile -t sink_descriptions < <(pactl list sinks | grep 'Description:' | sed -n -e 's/.*Description:[[:space:]]\([^\"]*\).*/\1/p')

# Find the index that matches our new active sink
for sink_index in "${!sink_descriptions[@]}"; do
  if [[ "$sink_index" == "$next_sink_index" ]] ; then
    notify-send -i audio-volume-high "Sound output switched to ${sink_descriptions[$sink_index]}"
    exit
  fi
done

