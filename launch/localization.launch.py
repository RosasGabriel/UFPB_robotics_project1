import os
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch_ros.actions import Node
from launch.substitutions import LaunchConfiguration
from ament_index_python.packages import get_package_share_directory


def generate_launch_description():
    # Get the package share directory
    pkg_robotics_class = get_package_share_directory('robotics_class')

    # Path to map file
    map_file_path = os.path.join(pkg_robotics_class, 'maps', 'class_map.yaml')

    # Declare launch arguments
    use_sim_time_arg = DeclareLaunchArgument(
        'use_sim_time',
        default_value='true',
        description='Use simulation/Gazebo clock'
    )

    use_sim_time = LaunchConfiguration('use_sim_time')

    # Map Server Node
    map_server = Node(
        package='nav2_map_server',
        executable='map_server',
        name='map_server',
        output='screen',
        parameters=[
            os.path.join(pkg_robotics_class, 'params', 'default.yaml'),
            {'yaml_filename': map_file_path},
            {'use_sim_time': use_sim_time}
        ]
    )

    # AMCL Node
    amcl = Node(
        package='nav2_amcl',
        executable='amcl',
        name='amcl',
        output='screen',
        parameters=[
            os.path.join(pkg_robotics_class, 'params', 'default.yaml'),
            {'use_sim_time': use_sim_time}
        ]
    )

    # Lifecycle Manager
    lifecycle_manager = Node(
        package='nav2_lifecycle_manager',
        executable='lifecycle_manager',
        name='lifecycle_manager_localization',
        output='screen',
        parameters=[{
            'use_sim_time': use_sim_time,
            'autostart': True,
            'node_names': ['map_server', 'amcl']
        }]
    )

    # Create and return the launch description
    return LaunchDescription([
        use_sim_time_arg,
        map_server,
        amcl,
        lifecycle_manager
    ])
