#!/bin/bash

# Script para parar Atividade 2 - Mata todos os processos e fecha terminais

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  🛑 PARANDO ATIVIDADE 2: Fechando tudo                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# 1. Matar processos ROS2 específicos
echo "🔴 Matando processos ROS2..."

pkill -f "ros2 launch robotics_class robot_description"
pkill -f "ros2 launch robotics_class simulation_world"
pkill -f "ros2 launch robotics_class ekf"
pkill -f "ros2 launch robotics_class localization"
pkill -f "teleop_twist_keyboard"
pkill -f "rviz2"

sleep 1

# 2. Matar Gazebo
echo "🔴 Matando Gazebo..."
pkill -f "gazebo"
pkill -f "gzserver"
pkill -f "gzclient"

sleep 1

# 3. Matar outros processos ROS2 genéricos
echo "🔴 Matando outros processos ROS2..."
pkill -f "ros2"

sleep 1

# 4. Fechar todos os terminais gnome-terminal abertos
echo "🔴 Fechando terminais..."
pkill -f "gnome-terminal"

sleep 1

# 5. Limpeza extra (se necessário)
echo "🔴 Limpeza final..."
pkill -f "robot_state_publisher"
pkill -f "joint_state_publisher"

echo ""
echo "✅ Todos os processos foram encerrados!"
echo "✅ Todos os terminais foram fechados!"
echo ""
echo "💡 Se algum processo persistir, execute:"
echo "   killall -9 gzserver gzclient gazebo"
echo ""
