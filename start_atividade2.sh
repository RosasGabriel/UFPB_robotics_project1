#!/bin/bash

# Script para Atividade 2 - Localização com AMCL (Código da Equipe)

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  📍 ATIVIDADE 2: Localização com AMCL (Parte B)         ║"
echo "║  Código da Equipe - 6 TERMINAIS                         ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Obter diretório do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verificar se o workspace foi compilado
if [ ! -f "$SCRIPT_DIR/install/setup.bash" ]; then
    echo "❌ ERRO: Workspace não compilado!"
    echo ""
    echo "Execute primeiro:"
    echo "  cd $SCRIPT_DIR"
    echo "  colcon build"
    echo ""
    exit 1
fi

echo "✅ Workspace compilado"
echo ""

# Terminal 1: Robot Description
gnome-terminal --title="1-Robot Description" --geometry=80x24+0+0 -- bash -c "
    source \"$SCRIPT_DIR/install/setup.bash\"
    echo '═══════════════════════════════════════════════════'
    echo '🤖 TERMINAL 1/6: Descrição do Robô'
    echo '═══════════════════════════════════════════════════'
    echo ''
    ros2 launch robotics_class robot_description.launch.py
    exec bash
" &

sleep 2

# Terminal 2: Gazebo Simulation
gnome-terminal --title="2-Gazebo Simulation" --geometry=80x24+700+0 -- bash -c "
    source \"$SCRIPT_DIR/install/setup.bash\"
    echo '═══════════════════════════════════════════════════'
    echo '🌍 TERMINAL 2/6: Simulação Gazebo'
    echo '═══════════════════════════════════════════════════'
    echo 'Aguarde o Gazebo abrir (~15 segundos)...'
    echo ''
    ros2 launch robotics_class simulation_world.launch.py
    exec bash
" &

sleep 6

# Terminal 3: EKF
gnome-terminal --title="3-EKF Filter" --geometry=80x24+0+350 -- bash -c "
    source \"$SCRIPT_DIR/install/setup.bash\"
    echo '═══════════════════════════════════════════════════'
    echo '📊 TERMINAL 3/6: Filtro EKF'
    echo '═══════════════════════════════════════════════════'
    echo ''
    ros2 launch robotics_class ekf.launch.py
    exec bash
" &

sleep 3

# Terminal 4: AMCL Localization
gnome-terminal --title="4-AMCL Localization" --geometry=80x24+700+350 -- bash -c "
    source \"$SCRIPT_DIR/install/setup.bash\"
    echo '═══════════════════════════════════════════════════'
    echo '📍 TERMINAL 4/6: AMCL + Map Server'
    echo '═══════════════════════════════════════════════════'
    echo 'Carregando mapa class_map.yaml...'
    echo 'Iniciando localização com AMCL...'
    echo ''
    echo '✅ Configuração:'
    echo '   - Mapa: class_map.yaml'
    echo '   - Partículas: 500-2000'
    echo '   - Modelo: DifferentialMotionModel'
    echo ''
    ros2 launch robotics_class localization.launch.py
    exec bash
" &

sleep 8

# Terminal 5: RViz Localization
gnome-terminal --title="5-RViz Localization" --geometry=80x24+0+700 -- bash -c "
    source \"$SCRIPT_DIR/install/setup.bash\"
    echo '═══════════════════════════════════════════════════'
    echo '👁️  TERMINAL 5/6: RViz (Localização)'
    echo '═══════════════════════════════════════════════════'
    echo 'Abrindo RViz com visualização de localização...'
    echo ''
    echo '📋 Você deve ver:'
    echo '   ✅ Mapa (fundo cinza/preto)'
    echo '   ✅ LaserScan (pontos vermelhos)'
    echo '   ✅ PoseWithCovariance (elipse de incerteza)'
    echo '   ✅ Modelo 3D do robô'
    echo ''
    echo '⚠️  IMPORTANTE - Defina a pose inicial:'
    echo '   1. Clique em \"2D Pose Estimate\" (seta verde)'
    echo '   2. Clique no mapa onde o robô está'
    echo '   3. Arraste na direção que o robô aponta'
    echo '   4. Solte o mouse'
    echo ''
    echo 'Aguarde RViz abrir...'
    sleep 2
    rviz2 -d \$(ros2 pkg prefix robotics_class)/share/robotics_class/rviz/localization_view.rviz
    exec bash
" &

sleep 4

# Terminal 6: Teleop
gnome-terminal --title="6-Teleop [TESTE A LOCALIZAÇÃO]" --geometry=90x30+350+200 -- bash -c "
    source \"$SCRIPT_DIR/install/setup.bash\"
    echo '═══════════════════════════════════════════════════════════'
    echo '🎮 TERMINAL 6/6: Controle do Robô (TELEOP)'
    echo '═══════════════════════════════════════════════════════════'
    echo ''
    echo '⚡ MANTENHA ESTA JANELA ATIVA PARA CONTROLAR!'
    echo ''
    echo '📋 Teclas de Movimento:'
    echo '   ┌─────────────────────────────────┐'
    echo '   │   i = Frente                    │'
    echo '   │   , = Trás                      │'
    echo '   │   j = Girar Esquerda            │'
    echo '   │   l = Girar Direita             │'
    echo '   │   k = Parar                     │'
    echo '   │                                 │'
    echo '   │   q = Aumentar velocidade       │'
    echo '   │   z = Diminuir velocidade       │'
    echo '   └─────────────────────────────────┘'
    echo ''
    echo '📍 COMO TESTAR A LOCALIZAÇÃO:'
    echo '   1. Defina pose inicial no RViz (2D Pose Estimate)'
    echo '   2. Observe nuvem de partículas aparecer'
    echo '   3. Movimente o robô'
    echo '   4. Observe:'
    echo '      ✓ Partículas convergindo'
    echo '      ✓ Elipse diminuindo'
    echo '      ✓ Robô localizado no mapa'
    echo ''
    echo '   ⚡ Velocidades: Linear 2.0x | Angular 3.0x'
    echo ''
    echo '🎯 Teste em diferentes locais do mapa!'
    echo ''
    echo '═══════════════════════════════════════════════════════════'
    echo ''
    echo 'Aguarde 3 segundos...'
    sleep 3
    ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args --remap cmd_vel:=jetauto/cmd_vel -p speed:=2.0 -p turn:=3.0
    exec bash
" &

echo ""
echo "✅ Todos os 6 terminais foram abertos!"
echo ""
echo "📋 Aguarde ~25 segundos para tudo inicializar"
echo ""
echo "🎯 Sistema Atividade 2 (Código da Equipe):"
echo "  1️⃣  Robot Description - Rodando"
echo "  2️⃣  Gazebo - Janela 3D com o robô"
echo "  3️⃣  EKF - Filtro de odometria"
echo "  4️⃣  AMCL + Map Server - Localização ativa"
echo "  5️⃣  RViz - Visualização com covariância"
echo "  6️⃣  Teleop - Controle do robô"
echo ""
echo "📍 PRÓXIMOS PASSOS CRÍTICOS:"
echo ""
echo "  1. Aguarde o RViz abrir completamente"
echo "  2. No RViz, clique no botão '2D Pose Estimate'"
echo "  3. Clique no mapa onde o robô está no Gazebo"
echo "  4. Arraste para a direção que o robô aponta"
echo "  5. Você verá partículas verdes aparecerem!"
echo "  6. Movimente o robô e veja a localização convergir"
echo ""
echo "💡 DICA: Se não vir partículas, redefina a pose inicial!"
echo ""
echo "📊 Verificar se está funcionando:"
echo "  ros2 topic echo /amcl_pose"
echo "  ros2 topic echo /particle_cloud"
echo ""
