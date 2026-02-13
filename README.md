# 📍 Atividade 2: Localização com AMCL

## 📋 Descrição

Esta pasta contém os arquivos necessários para a **Atividade 2** - Localização do robô JetAuto usando AMCL (Adaptive Monte Carlo Localization) e Map Server.

## 📁 Estrutura

```
atividade2_localization/
├── launch/
│   └── localization.launch.py    # Launch do AMCL + Map Server
├── params/
│   └── localization.yaml         # Configuração AMCL e Map Server
├── maps/
│   ├── class_map.yaml            # Metadados do mapa (você deve copiar)
│   └── class_map.pgm             # Imagem do mapa (você deve copiar)
└── rviz/
    └── localization_view.rviz    # Visualização RViz pré-configurada
```

## 🚀 Como Executar

### Opção 1: Script Automático (Recomendado)
```bash
~/start_localization.sh
```

### Opção 2: Manual
Consulte: `~/GUIA_ATIVIDADE2_LOCALIZATION.md`

## 📝 Pré-requisitos

1. **Ter um mapa salvo** da Atividade 1 (SLAM)
2. **Copiar o mapa** para a pasta `maps/` desta atividade

### Como copiar o mapa:
```bash
# Se seu mapa se chama meu_mapa.yaml e meu_mapa.pgm
cp ~/meu_mapa.* ~/atividade2_localization/maps/
mv ~/atividade2_localization/maps/meu_mapa.yaml ~/atividade2_localization/maps/class_map.yaml
mv ~/atividade2_localization/maps/meu_mapa.pgm ~/atividade2_localization/maps/class_map.pgm
```

## 🎯 Componentes

### AMCL (Localização)
- **Arquivo:** `params/localization.yaml` (seção `amcl`)
- **Função:** Localizar o robô no mapa usando partículas
- **Tópico principal:** `/amcl_pose`

### Map Server
- **Arquivo:** `params/localization.yaml` (seção `map_server`)
- **Função:** Carregar e publicar o mapa
- **Tópico principal:** `/map`

### Launch File
- **Arquivo:** `launch/localization.launch.py`
- **Uso:** `ros2 launch localization.launch.py map:=../maps/class_map.yaml`
- **Parâmetros:**
  - `map`: Caminho para o arquivo YAML do mapa
  - `use_sim_time`: true (para simulação)

## 👀 Visualização no RViz

O arquivo `rviz/localization_view.rviz` já está configurado com:

1. **Map** - Mapa carregado (`/map`)
2. **LaserScan** - Dados do LIDAR (`/jetauto/lidar/scan`)
3. **PoseWithCovariance** - Pose e incerteza do robô (`/amcl_pose`)
4. **RobotModel** - Modelo 3D do robô
5. **TF** - Transformações de coordenadas

## 🎮 Como Usar

1. **Execute o script** `~/start_localization.sh`
2. **Aguarde** todos os terminais inicializarem (~20s)
3. **No RViz:**
   - Clique em "2D Pose Estimate"
   - Clique no mapa onde o robô está
   - Arraste na direção do robô
4. **Movimente o robô** usando o teleop (Terminal 6)
5. **Observe** a localização convergir

## ✅ Verificação

### Tópicos importantes:
```bash
# Pose do AMCL
ros2 topic echo /amcl_pose

# Nuvem de partículas
ros2 topic echo /particle_cloud

# Mapa
ros2 topic echo /map
```

### Nós que devem estar rodando:
```bash
ros2 node list
```
Deve mostrar:
- `/amcl`
- `/map_server`
- `/lifecycle_manager_localization`

## 🔧 Parâmetros Importantes (localization.yaml)

### AMCL:
- `max_particles`: 2000 (número máximo de partículas)
- `min_particles`: 500 (número mínimo de partículas)
- `laser_max_range`: 11.0 (alcance máximo do laser)
- `update_min_d`: 0.25 (distância mínima para atualizar)
- `update_min_a`: 0.2 (ângulo mínimo para atualizar)

### Map Server:
- `yaml_filename`: Caminho para o mapa (passado via launch)
- `topic_name`: "map"
- `frame_id`: "map"

## 📚 Documentação

- **Guia Completo:** `~/GUIA_ATIVIDADE2_LOCALIZATION.md`
- **AMCL Docs:** https://docs.nav2.org/configuration/packages/configuring-amcl.html
- **Map Server Docs:** https://docs.nav2.org/configuration/packages/configuring-map-server.html

## 🆘 Problemas Comuns

### "Mapa não carrega"
- Verifique se `class_map.yaml` e `class_map.pgm` existem em `maps/`
- Verifique o caminho no comando de launch

### "Nuvem de partículas não aparece"
- Defina a pose inicial com "2D Pose Estimate" no RViz
- Verifique se AMCL está rodando: `ros2 node list | grep amcl`

### "Localização não converge"
- Defina uma pose inicial mais precisa
- Mova o robô mais devagar
- Verifique se o mapa está correto

## 🎓 Resultados Esperados

Ao final você deve ver:
- ✅ Mapa carregado no RViz
- ✅ Robô localizado no mapa
- ✅ Nuvem de partículas convergindo
- ✅ Elipse de covariância pequena
- ✅ Robô se mantendo localizado durante movimento
