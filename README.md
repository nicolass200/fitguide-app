# FitGuide

Aplicativo mobile desenvolvido em Flutter para consulta de exercícios físicos por grupo muscular e criação de treinos personalizados.

O objetivo do FitGuide é ajudar alunos de academia a consultar exercícios, visualizar imagens/GIFs demonstrativos, entender a execução básica e montar seus próprios treinos sem depender de fichas em papel.

---

## Sobre o projeto

O FitGuide foi desenvolvido como projeto da disciplina de Desenvolvimento Mobile.

O aplicativo permite:

- Visualizar grupos musculares;
- Listar exercícios por grupo muscular;
- Ver detalhes do exercício com imagem/GIF e instruções;
- Selecionar exercícios para montar um treino;
- Definir número de séries com slider;
- Salvar treinos personalizados localmente;
- Editar e excluir treinos salvos;
- Persistir dados usando SQLite;
- Utilizar API externa para carregamento dos exercícios;
- Utilizar preferências locais com SharedPreferences.

---

## Tecnologias utilizadas

- Flutter
- Dart
- WorkoutX API
- Dio
- SQLite / Sqflite
- SharedPreferences
- Provider
- Android Studio / VS Code

---

## Funcionalidades implementadas

### Consulta de exercícios

O app consome dados da WorkoutX API para buscar exercícios por grupo muscular.

Cada exercício pode exibir:

- Nome;
- Imagem/GIF demonstrativo;
- Grupo muscular;
- Instruções de execução.

> Observação: os dados dos exercícios vêm diretamente da WorkoutX API. Por isso, alguns nomes e instruções podem aparecer em inglês, conforme o retorno original da API.

---

### Montagem de treinos

O usuário pode montar treinos personalizados selecionando exercícios e definindo a quantidade de séries.

Funcionalidades disponíveis:

- Selecionar exercícios com checkbox;
- Definir séries de 1 a 6 com slider;
- Validar formulário antes de salvar;
- Salvar treino no banco local;
- Visualizar treinos salvos;
- Editar nome do treino;
- Excluir treino.

---

### Armazenamento local

O aplicativo utiliza SQLite para armazenar os treinos criados pelo usuário.

Mesmo após fechar e abrir o aplicativo novamente, os treinos permanecem salvos.

---

## Requisitos atendidos

| Requisito | Status |
|---|---|
| Interface com layout responsivo | Concluído |
| Tela inicial com grupos musculares | Concluído |
| Lista de exercícios por grupo | Concluído |
| Tela de detalhes do exercício | Concluído |
| Consumo de API REST | Concluído |
| Exibição de imagem/GIF dos exercícios | Concluído |
| Entrada de dados com formulário | Concluído |
| Validação de formulário | Concluído |
| Checkbox para selecionar exercícios | Concluído |
| Slider para definir séries | Concluído |
| Navegação entre telas | Concluído |
| Armazenamento local com SQLite | Concluído |
| CRUD de treinos | Concluído |
| SharedPreferences | Implementado/Utilizado no app |
| Cronômetro de descanso | Implementado como diferencial |

---

## Estrutura principal do projeto

```text
lib/
├── core/
│   ├── constants/
│   └── errors/
├── models/
│   ├── exercise.dart
│   ├── muscle_group.dart
│   └── workout.dart
├── screens/
│   ├── home_screen.dart
│   ├── exercise_list_screen.dart
│   ├── exercise_detail_screen.dart
│   └── my_workouts_screen.dart
├── services/
│   ├── workoutx_api_service.dart
│   └── workout_database_service.dart
├── widgets/
│   ├── exercise_card.dart
│   ├── muscle_group_card.dart
│   └── rest_timer_widget.dart
└── main.dart

```
---

# Como executar o projeto no VS Code

## 1. Pré-requisitos

Antes de executar o projeto, é necessário ter instalado:

- Flutter SDK;
- Dart;
- VS Code;
- Extensão Flutter no VS Code;
- Extensão Dart no VS Code;
- Android Studio instalado;
- Emulador Android configurado ou celular físico conectado.


Caso apareça algum problema relacionado às licenças do Android, execute:

```bash
flutter doctor --android-licenses
```

---

## 2. Clonar ou baixar o projeto

 Pode baixar o projeto pelo GitHub clicando em:

```text
Code > Download ZIP
```

Ou clonar pelo terminal:

```bash
git clone https://github.com/nicolass200/fitguide-app.git
```

Depois, abra a pasta do projeto no VS Code.

---

## 3. Instalar as dependências

Com o projeto aberto no VS Code, abra o terminal integrado:

```text
Terminal > New Terminal
```

Depois execute:

```bash
flutter pub get
```

---

## 4. Chave da API WorkoutX

O aplicativo utiliza a WorkoutX API para carregar os exercícios e GIFs.

Para facilitar a execução durante a avaliação, a chave da API utilizada no projeto está abaixo:

```text
WORKOUTX_API_KEY=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34
```



## 5. Executar o aplicativo pelo VS Code

Com o emulador Android aberto ou um celular físico conectado, execute no terminal:

```bash
flutter run --dart-define=WORKOUTX_API_KEY=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34
```

Exemplo:

```bash
flutter run --dart-define=WORKOUTX_API_KEY=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34```

---

## 6. Selecionar dispositivo no VS Code

Caso tenha mais de um dispositivo disponível:

1. No canto inferior direito do VS Code, clique no nome do dispositivo.
2. Selecione o emulador Android ou celular conectado.
3. Execute novamente:

```bash
flutter run --dart-define=WORKOUTX_API_KEY=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34
```

Também é possível listar os dispositivos disponíveis com:

```bash
flutter devices
```

---

## 7. Possíveis problemas

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

---

## Comando principal para avaliação

```bash
flutter pub get
flutter run --dart-define=WORKOUTX_API_KEY=wx_3d423d7d392f27ea1799bc1ed1ca316a79c664a403e44217f3911f34```

---

## Observações importantes

- O aplicativo precisa de internet para carregar os exercícios da WorkoutX API.
- Os treinos criados são salvos localmente usando SQLite.
- A chave da API deve ser informada no comando de execução.
- Algumas informações dos exercícios podem aparecer em inglês porque são retornadas diretamente pela API externa.
- O aplicativo foi desenvolvido para fins acadêmicos e pode conter limitações ou bugs.
