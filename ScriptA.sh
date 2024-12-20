#!/bin/bash

# Function to start a container on a specific CPU core
launch_container() {
  container_name=$1
  cpu_core=$2
  # Check if the container exists
  if docker ps -a --format '{{.Names}}' | grep -q "$container_name"; then
    # If the container is not running, remove it
    if ! docker ps --format '{{.Names}}' | grep -q "$container_name"; then
      docker rm "$container_name"
    else
      echo "Container $container_name is already running."
      return
    fi
  fi
  # Start the container on the specified CPU core
  echo "Starting $container_name on core $cpu_core..."
  docker run -d --name "$container_name" --cpuset-cpus="$cpu_core" kovalvlada/optimaserver
  sleep 10  # Allow the container to initialize
}

# Function to retrieve container CPU usage
get_cpu_usage() {
  container_name=$1
  # Get the CPU usage percentage of the container
  docker stats "$container_name" --no-stream --format "{{.CPUPerc}}" | sed 's/%//'
}

# Function to refresh all active containers
update_containers() {
  echo "Fetching the latest image..."
  docker pull kovalvlada/optimaserver

  # Map container names to CPU cores
  declare -A core_allocation=( ["app1"]=0 ["app2"]=1 ["app3"]=2 )

  # Iterate through each container and refresh if running
  for container_name in app1 app2 app3; do
    if docker ps --format '{{.Names}}' | grep -q "$container_name"; then
      echo "Stopping $container_name for refresh..."
      docker stop "$container_name"
      docker rm "$container_name"
      echo "Restarting $container_name..."
      launch_container "$container_name" "${core_allocation[$container_name]}"
    fi
  done
}

# Main loop logic
last_update_check=$(date +%s)
while true; do
  # Ensure app1 is running
  launch_container app1 0
  echo "Inspecting app1..."
  if docker ps --format '{{.Names}}' | grep -q app1; then
    usage1=$(get_cpu_usage app1)
    sleep 20
    usage2=$(get_cpu_usage app1)
    # Check if app1 is heavily loaded
    if (( $(echo "$usage1 > 80" | bc -l) && $(echo "$usage2 > 80" | bc -l) )); then
      echo "app1 is heavily loaded for 2 consecutive checks. Inspecting app2..."
      # Start app2 if not running
      if ! docker ps --format '{{.Names}}' | grep -q app2; then
        launch_container app2 1
      fi
    fi
  fi

  # Check app2 status
  if docker ps --format '{{.Names}}' | grep -q app2; then
    usage1=$(get_cpu_usage app2)
    sleep 20
    usage2=$(get_cpu_usage app2)
    # Check if app2 is heavily loaded
    if (( $(echo "$usage1 > 80" | bc -l) && $(echo "$usage2 > 80" | bc -l) )); then
      echo "app2 is heavily loaded for 2 consecutive checks. Inspecting app3..."
      # Start app3 if not running
      if ! docker ps --format '{{.Names}}' | grep -q app3; then
        launch_container app3 2
      fi
    # Check if app2 is idle
    elif (( $(echo "$usage1 < 10" | bc -l) && $(echo "$usage2 < 10" | bc -l) )); then
      echo "app2 is idle for 2 consecutive checks. Stopping it..."
      docker stop app2
      docker rm app2
    fi
  fi

  # Check app3 status
  if docker ps --format '{{.Names}}' | grep -q app3; then
    usage1=$(get_cpu_usage app3)
    sleep 20
    usage2=$(get_cpu_usage app3)
    # Check if app3 is idle
    if (( $(echo "$usage1 < 10" | bc -l) && $(echo "$usage2 < 10" | bc -l) )); then
      echo "app3 is idle for 2 consecutive checks. Stopping it..."
      docker stop app3
      docker rm app3
    fi
  fi

  # Check for new image version every 10 minutes
  current_time=$(date +%s)
  if (( current_time - last_update_check >= 600 )); then
    echo "Checking for new image version..."
    if docker pull kovalvlada/optimaserver | grep -q 'Downloaded newer image'; then
      echo "New image version detected. Refreshing containers..."
      declare -A core_allocation=( ["app1"]=0 ["app2"]=1 ["app3"]=2 )
      # Refresh each running container
      for container_name in app1 app2 app3; do
        if docker ps --format '{{.Names}}' | grep -q "$container_name"; then
          echo "Refreshing $container_name..."
          docker stop "$container_name"
          docker rm "$container_name"
          launch_container "$container_name" "${core_allocation[$container_name]}"
          sleep 10  # Ensure at least one container is active before refreshing the next
        fi
      done
    fi
    last_update_check=$current_time
  fi

  sleep 20
done