# This script must be placed on the root directory of the project to be executed

#!/bin/bash

killall -9 gzserver gzclient

colcon build

gnome-terminal -- bash -c "source install/setup.bash; ros2 launch robotics_class simulation_world.launch.py; exec bash"
sleep 10

gnome-terminal -- bash -c "source install/setup.bash; ros2 launch robotics_class robot_description.launch.py; exec bash"
sleep 10

gnome-terminal -- bash -c "source install/setup.bash; ros2 launch robotics_class ekf.launch.py; exec bash"
sleep 10

gnome-terminal -- bash -c "source install/setup.bash; ros2 launch robotics_class rviz.launch.py; exec bash"
sleep 10

gnome-terminal -- bash -c "source install/setup.bash;   ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args --remap cmd_vel:=jetauto/cmd_vel; exec bash"
sleep 10

gnome-terminal -- bash -c "source install/setup.bash; ros2 launch nav2_bringup navigation_launch.py; exec bash"
sleep 10

gnome-terminal -- bash -c "source install/setup.bash; ros2 launch robotics_class slam.launch.py; exec bash"