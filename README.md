# Brasil Cripto 🇧🇷 💰

Aplicativo para acompanhamento de criptomoedas em tempo real com múltiplas funcionalidades e suporte a personalização. 📱

## Arquitetura e Tecnologias 🏗️

O projeto foi desenvolvido utilizando Flutter 3.29.0 com uma arquitetura MVVM (Model-View-ViewModel) combinada com conceitos de Clean Architecture, organizando o código em camadas bem definidas:

- **Core**: Componentes fundamentais e serviços base
- **Features**: Funcionalidades organizadas em módulos independentes
- **Services**: Serviços de acesso a APIs e dados externos

### Padrão Arquitetural MVVM com State Partner 🧩

O projeto segue o padrão MVVM adaptado para Flutter com a implementação do State Partner para facilitar a comunicação entre camadas:

- **View**: Camada de UI responsável apenas pela renderização e captura de eventos do usuário. Implementada através de Widgets Flutter que se comunicam exclusivamente com sua ViewModel correspondente.

- **ViewModel**: Camada de lógica de apresentação que processa eventos da UI, gerencia estado e se comunica com os Repositories. Implementada com ChangeNotifier para notificar a View sobre mudanças de estado.

- **State Partner**: Padrão auxiliar que facilita a comunicação entre a View e a ViewModel, organizando o estado da aplicação de forma estruturada e garantindo a coesão entre as camadas.

- **Repository**: Camada responsável pela lógica de negócios e orquestração de fontes de dados. Abstrai a origem dos dados (API, banco local, etc) para as ViewModels.

- **DataSource**: Camada mais baixa responsável pelo acesso direto a fontes de dados externas (APIs) ou locais SharedPreferences.

### Tecnologias Principais ⚙️

- **Gerenciamento de Estado**: Utilizamos o ChangeNotifier nativo do Flutter, proporcionando uma solução leve e eficiente para gerenciar o estado do aplicativo.
- **Injeção de Dependência**: Implementamos o GetIt para gerenciar as dependências do aplicativo de forma limpa e testável.
- **Localização**: Suporte completo a múltiplos idiomas com easy_localization. 🌎
- **Persistência**: Armazenamento local para preferências de usuário e favoritos.

### Cache e Limitação de Taxa ⚡

Para otimizar o uso da API gratuita da CoinGecko e evitar atingir os limites de requisição, implementamos um sistema de cache:

- Cache de 1 minuto para requisições de cotações de moedas
- Armazenamento temporário das respostas da API para reduzir chamadas repetidas
- Sistema inteligente que retorna dados em cache quando o limite de requisições é atingido
- Diferentes tempos de cache por endpoint:
  - Cotações de mercado: 1 minuto
  - Detalhes de moedas: 2 minutos  
  - Pesquisas e tendências: 5 minutos


## Funcionalidades 🚀

### Cotações de Criptomoedas 📊
- Listagem das 20 principais criptomoedas do mercado
- Limitação na busca inicial por conta do uso da API gratuita da CoinGecko
- Possibilidade de buscar moedas adicionais através da barra de pesquisa 🔍
- Favoritos: Tela dedicada para visualização e gerenciamento das moedas favoritadas ⭐
- Persistência dos favoritos mesmo após fechar o aplicativo
- Sincronização em tempo real do status de favorito entre as telas


### Moedas de Referência 💱
Suporte a múltiplas moedas de referência para cotações:
- Real Brasileiro (BRL)
- Dólar Americano (USD)
- Euro (EUR)

### Personalização ⚙️
- **Temas**: Suporte a tema claro, escuro e configuração automática baseada no sistema 🌓
- **Idiomas**: Suporte completo a Português do Brasil e Inglês 🌎
- **Favoritos**: Possibilidade de marcar moedas como favoritas para acesso rápido ⭐

### Interface Responsiva 📱
- Design adaptativo para diferentes tamanhos de tela
- Experiência de usuário otimizada para Android e iOS

## Configuração do Projeto 🛠️

### Requisitos
- Flutter 3.29.0
- Dart SDK
- Android Studio / Visual Studio Code

### Configuração
1. Clone o repositório
2. Execute `flutter pub get` para instalar as dependências
3. Utilize o FVM (Flutter Version Management) para garantir a versão correta do Flutter
