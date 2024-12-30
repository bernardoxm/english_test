# Mobile Challenge 20240202

## **Estrutura do Projeto**

### **Arquivos Principais**
- **`main.dart`**: O ponto de entrada do aplicativo. Ele inicializa o Flutter e configura as dependências iniciais.
- **`.DS_Store`**: Arquivo do macOS que pode ser ignorado ou removido.

### **Diretórios**

#### **`models/`**
Contém as definições de modelos de dados utilizados no aplicativo.
- **`words_model.dart`**: Define a estrutura de dados para "palavras", incluindo atributos e métodos relacionados.

#### **`providers/`**
Diretório reservado para gerenciar o estado e fornecer dados para outras partes do aplicativo.
- **Atualmente vazio**: Pode ser utilizado para implementar provedores de estado no futuro.

#### **`screens/`**
Contém as telas principais do aplicativo.
- **`home_page.dart`**: Define a página inicial, responsável por exibir as funcionalidades principais do aplicativo.

#### **`services/`**
Contém a lógica de negócios e serviços auxiliares.
- **`api_words_service.dart`**: Implementa chamadas às APIs relacionadas à gestão e exibição de "palavras".

#### **`sql/`**
Gerencia a interação com o banco de dados local do aplicativo.
- **`sql_data_base.dart`**: Contém a lógica para inicialização, leitura, escrita e gerenciamento de dados no banco SQL.

#### **`widgets/`**
Inclui componentes reutilizáveis que podem ser utilizados em diversas partes do aplicativo.
- **`error_load_widget.dart`**: Exibe mensagens de erro durante o carregamento de dados.
- **`favorites_tab_widget.dart`**: Componente que representa a aba de "Favoritos".
- **`history_tab_widget.dart`**: Componente que representa a aba de "Histórico".
- **`show_words_details_widget.dart`**: Mostra os detalhes de uma palavra selecionada.
- **`word_list_tab_widget.dart`**: Exibe uma lista de palavras organizadas por tabs.

## **Requisitos do Ambiente**
Certifique-se de ter o seguinte configurado no seu ambiente antes de executar o projeto:
- **Flutter SDK**: Versão mais recente.
- **Dart**: Incluído no Flutter SDK.
- **Editor**: Recomendado usar o Visual Studio Code ou Android Studio.

## **Como Rodar o Projeto**
1. **Clone o repositório**:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   ```
2. **Navegue até o diretório do projeto**:
   ```bash
   cd <NOME_DO_DIRETORIO>
   ```
3. **Instale as dependências**:
   ```bash
   flutter pub get
   ```
4. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

## **Contribuição**
Contribuições são bem-vindas! Por favor, siga estas etapas:
1. **Fork o repositório**.
2. **Crie uma branch para sua modificação**:
   ```bash
   git checkout -b minha-modificacao
   ```
3. **Submeta um Pull Request com as alterações**.

**Licença**
Este projeto está licenciado sob os termos descritos no arquivo LICENSE.md. Consulte o arquivo para mais informações.
[LICENSE.md](https://github.com/user-attachments/files/18275078/LICENSE.md)MIT License

Copyright (c) 2024 [english\_test](https://github.com/bernardoxm/english_test)

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
SOFTWARE.  




