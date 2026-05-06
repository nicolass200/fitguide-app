# 💪 FitGuide

Aplicativo de academia para consulta de exercícios e montagem de treinos personalizados.

## 📱 Funcionalidades

- Consultar exercícios por grupo muscular (via WGER API)
- Visualizar execução com imagem e descrição
- Buscar exercícios por nome
- Montar e salvar treinos personalizados (SQLite)
- Timer de descanso com alerta sonoro ⏱
- Modo compacto de visualização

## 🛠 Tecnologias

| Tecnologia | Uso |
|---|---|
| Flutter 3+ | Framework principal |
| Provider | Gerenciamento de estado |
| Dio | Consumo da WGER API |
| SQLite (sqflite) | Persistência de treinos |
| SharedPreferences | Preferências do usuário |
| audioplayers | Alerta sonoro do timer |

## 🚀 Como rodar

### Pré-requisitos
- Flutter SDK 3.0+
- Android Studio ou VS Code
- Dispositivo ou emulador Android/iOS

### Passo a passo

```bash
# 1. Clone o repositório
git clone https://github.com/SEU_USUARIO/fitguide.git
cd fitguide

# 2. Instale as dependências
flutter pub get

# 3. Execute o app
flutter run
```

> **Nenhuma chave de API é necessária.** O app usa a WGER API pública.

## 🗂 Estrutura do Projeto

```
lib/
├── main.dart                    # Entry point + configuração dos providers
├── core/
│   ├── constants/               # Constantes globais (URL da API, etc.)
│   ├── errors/                  # Exceções customizadas
│   └── theme/                   # Tema visual do app
├── models/                      # Modelos de dados (Exercise, Workout, etc.)
├── services/                    # Comunicação com API e banco local
├── providers/                   # Gerenciamento de estado (Provider)
├── screens/                     # Telas do aplicativo
└── widgets/                     # Componentes reutilizáveis
```

## 📋 Telas

| Tela | Descrição |
|---|---|
| `HomeScreen` | Grid de grupos musculares + switch modo compacto |
| `ExerciseListScreen` | Lista com busca por nome |
| `ExerciseDetailScreen` | Detalhe + slider séries + checkbox + timer |
| `MyWorkoutsScreen` | CRUD completo dos treinos salvos |

## 🧪 Executar testes

```bash
flutter test
```

## 📦 Gerar APK

```bash
flutter build apk --release
```

## 👤 Autor

Desenvolvido como projeto acadêmico — Disciplina Mobile (P2)
