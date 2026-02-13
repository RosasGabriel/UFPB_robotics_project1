from launch import LaunchDescription
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    #Caminho para o arquivo de parâmtros do SLAM
    slam_params_file = os.path.join(
        get_package_share_directory('robotics_class'), # Nome do pacote
        'params', # Pasta dos arquivos de parametros
        'default.yaml' # Nome do arquivo de parâmetros
    )

    # Nó do SLAM
    slam_toolbox_node = Node(
        package='slam_toolbox',
        executable='sync_slam_toolbox_node',  # Modo síncrono para melhor desempenho
        name='slam_toolbox',
        output='screen',
        parameters=[slam_params_file], #Carrega os parâmetros do YAML
        remappings=[
            ('/scan', '/jetauto/lidar/scan'), # Remapeamento do tópico de laser scan
        ]
    )

    return LaunchDescription([
        slam_toolbox_node,
    ])