# 💪 FitGuide

Aplicativo de academia desenvolvido em Flutter para consulta de exercícios por grupo muscular e montagem de treinos personalizados.

O objetivo do FitGuide é permitir que o usuário consulte exercícios, visualize GIFs/imagens demonstrativas, veja instruções de execução e crie seus próprios treinos salvos localmente.

---

## 📱 Funcionalidades

- Consultar exercícios por grupo muscular usando a WorkoutX API;
- Visualizar exercícios com nome, GIF/imagem e instruções;
- Buscar exercícios por nome;
- Visualizar detalhes do exercício;
- Selecionar exercícios para montar um treino;
- Definir número de séries com slider;
- Salvar treinos personalizados usando SQLite;
- Listar treinos salvos;
- Editar nome dos treinos;
- Excluir treinos;
- Timer de descanso com alerta sonoro;
- Modo compacto de visualização usando SharedPreferences.

> Observação: alguns nomes e instruções dos exercícios podem aparecer em inglês, pois são retornados diretamente pela API externa WorkoutX.

---

## 🛠 Tecnologias utilizadas

| Tecnologia | Uso |
|---|---|
| Flutter 3+ | Framework principal |
| Dart | Linguagem de programação |
| Provider | Gerenciamento de estado |
| Dio | Consumo da WorkoutX API |
| SQLite / sqflite | Persistência local dos treinos |
| SharedPreferences | Preferências do usuário |
| audioplayers | Alerta sonoro do timer |
| Android Studio / VS Code | Ambiente de desenvolvimento |

---

## 🚀 Como executar o projeto no VS Code

### 1. Pré-requisitos

Antes de executar o projeto, é necessário ter instalado:

- Flutter SDK;
- Dart;
- VS Code;
- Extensão Flutter no VS Code;
- Extensão Dart no VS Code;
- Android Studio instalado;
- Emulador Android configurado ou celular físico conectado.

Para verificar se o Flutter está configurado corretamente, abra o terminal e execute:

```bash
flutter doctor
```

Caso apareça algum problema relacionado às licenças do Android, execute:

```bash
flutter doctor --android-licenses
```

---

### 2. Clonar ou baixar o projeto

O professor pode baixar o projeto pelo GitHub clicando em:

```text
Code > Download ZIP
```

Ou clonar pelo terminal:

```bash
git clone https://github.com/nicolass200/fitguide-app.git
```

Depois, abra a pasta do projeto no VS Code.

---

### 3. Instalar as dependências

Com o projeto aberto no VS Code, abra o terminal integrado:

```text
Terminal > New Terminal
```

Depois execute:

```bash
flutter pub get
```

---

### 4. Chave da API WorkoutX

O aplicativo utiliza a WorkoutX API para carregar os exercícios e GIFs.

Para facilitar a execução durante a avaliação, a chave da API utilizada no projeto está abaixo:

```text
WORKOUTX_API_KEY=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34
```

Substitua `SUA_CHAVE_DA_API_AQUI` pela chave real da API.

---

### 5. Executar o aplicativo pelo VS Code

Com o emulador Android aberto ou um celular físico conectado, execute no terminal:

```bash
flutter run --dart-define=WORKOUTX_API_KEY=SUA_CHAVE_DA_API_AQUI
```

Exemplo:

flutter run --dart-define=WORKOUTX_API_KEY=coloque_a_chave_real_aqui
```

---

### 6. Selecionar dispositivo no VS Code

Caso tenha mais de um dispositivo disponível:

1. No canto inferior direito do VS Code, clique no nome do dispositivo.
2. Selecione o emulador Android ou celular conectado.
3. Execute novamente:

```bash
flutter run --dart-define=WORKOUTX_API_KEY=SUA_CHAVE_DA_API_AQUI
```

Também é possível listar os dispositivos disponíveis com:

```bash
flutter devices
```

---

## ⚠️ Possíveis problemas

### Exercícios não carregam

Verifique se:

- A chave da API foi informada corretamente;
- O comando foi executado com `--dart-define`;
- O computador está conectado à internet;
- O emulador ou celular tem acesso à internet.

Comando correto:

```bash
flutter run --dart-define=WORKOUTX_API_KEY=SUA_CHAVE_DA_API_AQUI
```

---

### Erro de dependências

Execute:

```bash
flutter clean
flutter pub get
```

Depois rode novamente:

```bash
flutter run --dart-define=WORKOUTX_API_KEY=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34
```

---

## ✅ Comando principal para avaliação

Execute estes comandos dentro da pasta do projeto:

```bash
flutter pub get
flutter run --dart-define=WORKOUTX_API_KEY=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34
```

---

## 🗂 Estrutura do Projeto

```text
lib/
├── main.dart                    # Entry point e configuração dos providers
├── core/
│   ├── constants/               # Constantes globais
│   ├── errors/                  # Exceções customizadas
│   └── theme/                   # Tema visual do app
├── models/                      # Modelos de dados
├── services/                    # Comunicação com API e banco local
├── providers/                   # Gerenciamento de estado
├── screens/                     # Telas do aplicativo
└── widgets/                     # Componentes reutilizáveis
```

---

## 📋 Telas do aplicativo

| Tela | Descrição |
|---|---|
| `HomeScreen` | Tela inicial com grupos musculares e modo compacto |
| `ExerciseListScreen` | Lista de exercícios com busca por nome |
| `ExerciseDetailScreen` | Detalhes do exercício, GIF, instruções, slider, checkbox e timer |
| `MyWorkoutsScreen` | Tela de treinos salvos com CRUD |

---

## 💾 Armazenamento local

O aplicativo utiliza SQLite para salvar os treinos criados pelo usuário.

Os dados permanecem salvos mesmo após fechar e abrir o aplicativo novamente.

---

## 🧪 Executar testes

```bash
flutter test
```

---

## 📦 Gerar APK

```bash
flutter build apk --release --dart-define=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34
```

---

## 📝 Observações importantes

- O aplicativo precisa de internet para carregar os exercícios da WorkoutX API.
- A chave da API deve ser informada usando `--dart-define`.
- Os treinos são salvos localmente usando SQLite.
- O modo compacto utiliza SharedPreferences.
- Algumas informações dos exercícios podem aparecer em inglês porque são retornadas diretamente pela API externa.
- O app foi desenvolvido como projeto acadêmico da disciplina de Desenvolvimento Mobile.

---

## 👤 Autor

Desenvolvido como projeto acadêmico — Disciplina Mobile (P2).

Nome: NICOLAS RODRIGUES FERREIRA DE CARVALHO
Disciplina: Desenvolvimento Mobile  
Curso: Engenharia de Software