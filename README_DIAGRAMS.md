# Gerar Diagramas UML

Este diretório contém arquivos PlantUML (.puml) para gerar os diagramas UML da arquitetura.

## Arquivos de Diagramas

1. **`architecture_class_diagram.puml`** - Diagrama de Classes
2. **`architecture_sequence_diagram.puml`** - Diagrama de Sequência (CRUD)
3. **`architecture_component_diagram.puml`** - Diagrama de Componentes (Camadas)

## Como Gerar os SVGs

### Opção 1: PlantUML Local

```bash
# Instalar PlantUML (requer Java)
# macOS: brew install plantuml
# Ubuntu: sudo apt-get install plantuml
# Windows: Download do site oficial

# Gerar todos os diagramas
plantuml -tsvg *.puml

# Ou individualmente
plantuml -tsvg architecture_class_diagram.puml
plantuml -tsvg architecture_sequence_diagram.puml  
plantuml -tsvg architecture_component_diagram.puml
```

### Opção 2: PlantUML Online

1. Acesse: https://www.plantuml.com/plantuml/uml
2. Cole o conteúdo de qualquer arquivo `.puml`
3. Clique em "Submit"
4. Download do SVG gerado

### Opção 3: VS Code Extension

1. Instale a extensão "PlantUML" 
2. Abra qualquer arquivo `.puml`
3. Pressione `Alt+D` para preview
4. Clique com botão direito → "Export Current Diagram"

## Diagramas Esperados

### **Diagrama de Classes**
- Mostra todas as classes das 4 camadas
- Relacionamentos entre interfaces e implementações  
- Padrões de projeto visualizados (Repository, DAO, Factory, DI)

### **Diagrama de Sequência**
- Fluxo CRUD completo: UI → Store → Repository → DAO → Database
- Mostra chamadas assíncronas e retorno de Results
- Visualiza padrão Repository + DAO em ação

### **Diagrama de Componentes** 
- Organização das 4 camadas (Core, Domain, Data, Presentation)
- Dependências entre camadas seguindo Clean Architecture
- Abstrações (interfaces) isolando implementações

## Resultados

Após gerar, você terá:

```
/
├── uml.svg                            # Diagrama de classes atual
├── uml2.svg                           # Diagrama de sequência atual
├── architecture_class_diagram.svg     # Diagrama de classes refatorado
├── architecture_sequence_diagram.svg  # Diagrama de sequência refatorado
└── architecture_component_diagram.svg # Diagrama de componentes refatorado
```

## Versionamento dos Diagramas

### Versão Original (uml.svg, uml2.svg)
- Estrutura monolítica com main.dart de 447 linhas
- Sem separação de camadas
- Tight coupling entre UI e Database

### Versão Refatorada (architecture_*.svg)
- Clean Architecture com 4 camadas bem definidas
- Padrões de projeto implementados
- Dependency inversion e injeção de dependências
- Multiplataforma com Factory pattern

## Comandos Úteis

```bash
# Gerar apenas o diagrama de classes
plantuml -tsvg architecture_class_diagram.puml

# Gerar com formato PNG (melhor para documentação)
plantuml -tpng *.puml

# Gerar com tema escuro
plantuml -tsvg -config plantuml.cfg *.puml

# Ver versão do PlantUML
plantuml -version
```
