![Manuskript Banner](https://img.shields.io/badge/Manuskript-Organizador%20de%20Ideias-blue?style=for-the-badge)
![Platform](https://img.shields.io/badge/iOS%20%2F%20iPadOS-only-black?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/status-em%20desenvolvimento-orange?style=for-the-badge)

<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&color=0:99B7F5,100:E0E1FF&height=240&section=header&text=ReUne!%20&fontSize=50&fontColor=fff&animation=twinkling&fontAlignY=40">

# ReUne: organize encontros em grupo

> Um app iOS para marcar encontros em grupo sem fricção: convide pelos contatos, vote em datas, horários e atividades, e veja o resultado consolidado automaticamente.

## Sobre o projeto

**ReUne** é um aplicativo para iPhone, escrito em **SwiftUI**, que resolve o clássico problema de "marcar algo com a galera": muita gente no grupo, ninguém concorda em data, horário ou atividade. Em vez de uma enquete manual, o ReUne cria um **grupo** vinculado a um conjunto de categorias (ex.: *Gastronomia*, *Esportes*, *Ao ar livre*), compartilha um link de convite por SMS, e deixa cada participante registrar sua própria disponibilidade (datas/horários) e suas atividades preferidas dentro daquelas categorias. A cada nova resposta, o app recalcula em tempo real:

- a **melhor data** (heatmap em calendário),
- o **melhor horário** (linha do tempo com os dois horários mais votados),
- e a **atividade mais votada** (nuvem de palavras, com a vencedora em destaque).

Não existe servidor próprio: todo o backend é **CloudKit** (a infraestrutura de nuvem da Apple), e a "conta" do usuário é só o ID do iCloud do dispositivo — sem e-mail, sem senha, sem cadastro.

## Funcionalidades

- **Login silencioso via iCloud**, sem formulário de cadastro: o ID do iCloud do dispositivo se torna a identidade do usuário no app.
- **Lista de grupos do usuário** ("Seus Grupos"), com pull-to-refresh e destaque animado (efeito *shimmer*) nos grupos novos ou recém-atualizados.
- **Criação de grupo**: seleção de contatos pela agenda do iPhone (`CNContactPickerViewController`) e escolha de uma ou mais categorias de encontro (10 categorias fixas: Ao ar livre, Bem-estar, Criatividade, Cultura e Entretenimento, Esportes, Festas, Festividades, Gastronomia, Viagem, Outros).
- **Convite por SMS** com um deep link (`ReUne://<idDoGrupo>`) gerado automaticamente ao criar o grupo, usando o compositor nativo de mensagens (`MFMessageComposeViewController`).
- **Entrada via link de convite**: abrir o link adiciona o usuário ao grupo (ou pede login com iCloud, se ele ainda não tiver) e leva direto ao formulário de respostas.
- **Formulário de disponibilidade**: cada participante adiciona uma ou mais datas/horários candidatos e escolhe atividades (dentro de um catálogo com mais de 180 opções, agrupadas pelas categorias do grupo) que ele gostaria de fazer.
- **Resultados do grupo**:
  - calendário mensal com **heatmap** mostrando a concentração de votos por dia;
  - linha do tempo (0h–23h) com os horários mais votados;
  - **nuvem de palavras** das atividades, com tamanho da fonte proporcional aos votos e a vencedora destacada.
- **Compartilhamento do link do grupo** a qualquer momento, com feedback visual de "link copiado".
- **Notificações push** por grupo (via `CKQuerySubscription`), avisando quando alguém entra, vota ou atualiza um grupo — com permissão pedida de forma assíncrona, fora do fluxo principal.
- **Exclusão de grupo ou de conta**, com confirmação e remoção dos dados no CloudKit.
- **Anúncios intersticiais** (Google Mobile Ads) exibidos esporadicamente — a cada 3 grupos abertos, ou depois de o usuário registrar sua disponibilidade — como modelo de monetização.
- **Analytics de produto** (Aptabase) instrumentado nos principais pontos de decisão: criação de grupo, número de participantes, categorias e atividades mais escolhidas, dias/horários mais votados, etc.

## Como funciona o fluxo do app

```
 Abrir o app
     │
     ▼
 EntryView ──(sem iCloud configurado)──► Alerta para configurar iCloud
     │
     ▼ (iCloud disponível, sem conta local ainda)
 Pergunta "Deseja criar uma conta?" + permissão de notificações
     │
     ▼
 HomeView ("Seus Grupos")
     │
     ├──► [+] Novo grupo ──► escolher contatos + categorias ──► enviar convite por SMS
     │
     ├──► Tocar em um grupo ──► GroupResultView (calendário, horários, nuvem de palavras)
     │
     └──► Abrir link "ReUne://<id>" recebido de alguém ──► entra no grupo ──► FormView
                                                                      │
                                                                      ▼
                                                       escolher datas + atividades
                                                                      │
                                                                      ▼
                                                       salva no grupo ──► GroupResultView
```

## Integração com CloudKit

O CloudKit é usado como banco de dados completo da aplicação, com dois bancos distintos:

- **Banco privado** (`privateCloudDatabase`): guarda o registro `preferences` de cada usuário (nome e ID do iCloud) — é a "tabela de usuários" do app.
- **Banco público** (`publicCloudDatabase`): guarda o registro `ItemListing`, que representa um grupo (`EventGroup`): categorias, atividades e respectivos votos, datas candidatas, conjunto de participantes (`users`) e o criador (`owner`).

Os grupos são buscados filtrando por `ANY users == <idDoUsuário>`, ou seja, qualquer participante consegue ver e editar o mesmo registro. Cada atualização (nova data, nova atividade, novo participante) é feita por *merge* no mesmo `CKRecord`, e o app dispara notificações por assinatura (`CKQuerySubscription`) para avisar o grupo sobre mudanças.

## Arquitetura e organização do código

O projeto segue **MVVM** com SwiftUI puro, persistência em **CloudKit** (sem Core Data) e gerenciamento de estado via `@Observable` / `ObservableObject`, dependendo do módulo.

```
ProjectChallenge13/
├── ProjectChallenge13App.swift        # @main; inicializa Aptabase e Google Mobile Ads; trata deep links "ReUne://"
├── Info.plist                          # URL scheme "ReUne", AdMob App ID, SKAdNetwork
├── ProjectChallenge13.entitlements     # iCloud container + CloudKit + Push Notifications
├── StoreKitProducts.storekit           # Configuração de testes do StoreKit (ainda sem produtos cadastrados)
│
├── Models/
│   ├── GroupModel.swift                # EventGroup (conversão CKRecord ↔ struct), CategoryModel, ActivitiesModel
│   ├── NewGroupModel.swift             # As 10 categorias fixas de encontro
│   ├── FormModel.swift                 # Catálogo com +180 atividades pré-cadastradas, por categoria
│   ├── PreferenceModel.swift           # Identidade do usuário (nome + ID do iCloud)
│   └── WordElement.swift               # Modelo de uma palavra na nuvem de atividades mais votadas
│
├── ViewModels/
│   ├── LoginViewModel.swift            # Login via iCloud (sem senha/e-mail), CRUD do registro `preferences`
│   ├── EntryViewModel.swift            # Verifica o status da conta iCloud no dispositivo
│   ├── GroupViewModel.swift            # CRUD de grupos no CloudKit (banco público)
│   ├── NewGroupViewModel.swift         # Estado da criação de um novo grupo (categorias selecionadas)
│   ├── ContactsViewModel.swift         # Contatos selecionados para o convite
│   ├── FormViewModel.swift             # Estado do formulário de disponibilidade/atividades
│   ├── CalendarViewModel.swift         # Agregação de datas/horários para o heatmap e a timeline
│   ├── WordCloudViewModel.swift        # Agrega votos por atividade para a nuvem de palavras
│   ├── PushNotificationViewModel.swift # Inscrição/cancelamento de notificações por grupo
│   └── AdManager.swift                 # Carregamento e exibição de anúncios intersticiais
│
└── Views/
    ├── ContentView.swift / EntryView.swift   # Onboarding de iCloud + permissão de notificações
    ├── HomeView.swift                         # Lista de grupos do usuário ("Seus Grupos")
    ├── NewGroup/                              # Sheet de criação de grupo (contatos, categorias, convite por SMS)
    ├── Form/                                  # Formulário de datas e atividades para votar
    ├── GroupResult/                           # Resultados: calendário heatmap, timeline de horários
    ├── WordCloudView.swift                    # Nuvem de palavras com layout em espiral
    └── Components/                            # Botões, card de grupo, animações (shimmer, progresso circular)
```

### Principais peças

- **`EventGroup` / `GroupViewModel`**: modelam e persistem um grupo no CloudKit, incluindo a conversão de/para `CKRecord` (categorias e atividades são serializadas como `Data` via `JSONEncoder`).
- **`LoginViewModel`**: cria e consulta o registro de identidade do usuário (`preferences`) usando o `CKRecord.ID` do iCloud como chave — funciona como um login "automático", sem tela de cadastro tradicional.
- **`AdManager`**: encapsula o SDK do Google Mobile Ads, carregando um intersticial e controlando a frequência de exibição (a cada 3 entradas em resultados de grupo, ou depois de responder ao formulário).
- **`WordCloudView` / `CloudLayout`**: algoritmo próprio de posicionamento em espiral para distribuir as palavras (atividades) sem sobreposição, com *fallback* em layout de linhas quando não há espaço suficiente.
- **`CalendarView` / `TimeLineView`**: visualizações customizadas (sem dependências externas) que aplicam opacidade proporcional ao número de votos para destacar dias e horários mais escolhidos.
- **`ShimmerBorderModifier` / `CircularProgressModifier`**: modificadores de animação reutilizáveis — destaque de borda animada em cards novos e feedback de progresso circular ao confirmar a criação de um grupo.

## Tecnologias

- **Swift 5** + **SwiftUI** (iOS 26 SDK)
- **CloudKit** (bancos público e privado) como backend, sem servidor próprio
- **Contacts / ContactsUI** para seleção de contatos do convite
- **MessageUI** para envio do SMS com o link de convite
- **UserNotifications** + assinaturas do CloudKit (`CKQuerySubscription`) para notificações push
- **[Aptabase](https://aptabase.com)** para analytics de produto (via Swift Package)
- **Google Mobile Ads SDK** para anúncios intersticiais
- **StoreKit** — configuração de testes já presente no projeto, preparada para um futuro plano premium (ainda sem produtos cadastrados)
- **Swift Testing** (`import Testing`) para testes unitários e **XCTest** para testes de UI

## Requisitos

- macOS com **Xcode** (versão compatível com Swift 5 / iOS 26 SDK)
- iOS **26.0+** (`IPHONEOS_DEPLOYMENT_TARGET`)
- Dispositivo de destino: **iPhone**
- Uma conta iCloud configurada no dispositivo/simulador (obrigatória — é a base do login e da sincronização dos grupos)
- Acesso à agenda de contatos e a SMS para testar o fluxo completo de convite

## Como executar

```bash
# Clone o repositório
git clone <url-do-repositorio>
cd ProjectChallenge13

# Abra o projeto no Xcode
open ProjectChallenge13/ProjectChallenge13.xcodeproj
```

No Xcode:
1. Selecione um simulador de iPhone (ou dispositivo físico) com iCloud configurado como destino de build.
2. Rode o projeto com `Cmd + R`.

> ⚠️ Os IDs do Google Mobile Ads usados no código (`AdManager.swift` e `Info.plist`) são valores de teste/placeholder. Antes de publicar o app, substitua-os pelos IDs reais do AdMob.

## Testes

O projeto contém os alvos `ProjectChallenge13Tests` (testes unitários, com `Testing`) e `ProjectChallenge13UITests` (testes de UI/performance, com `XCTest`).

- `ProjectChallenge13Tests.swift` já tem casos reais cobrindo `CalendarViewModel` (cálculo de opacidade, data/horário mais frequente, formatação de datas) e `NewGroupViewModel` (seleção/remoção de categorias).
- `ItemListViewModelTesting.swift`, `LoginViewModelTesting.swift` e `PushNotificationsViewModelTesting.swift` existem apenas como rascunhos comentados, ainda não habilitados — ponto natural para expandir a cobertura de CloudKit, login e notificações.
- Os testes de UI (`ProjectChallenge13UITests`) ainda estão como *placeholders* gerados pelo template padrão do Xcode.

## Identidade visual

A paleta do ReUne é construída em tons de **azul** — do azul-noite (`nightBlue`) ao azul ultramarino (`ultramarineBlue`), passando por um azul claro de fundo dos cards (`formCardBack`) — refletindo o ícone do app, composto por formas geométricas arredondadas nesses mesmos tons.

## Equipe

Projeto desenvolvido por:

| Anshu Li | Carolina Sun R. N. de Castilho | Francisco Losada | Rafael Neves de Oliveira | Vinicius A. Marques |
|----------|----------------------------------|-------------------|---------------------------|----------------------|
| <a href="https://github.com/Anshushu000"><img src="https://avatars.githubusercontent.com/u/162741474?v=4" height="120"></a> | <a href="https://github.com/carolssun"><img src="https://avatars.githubusercontent.com/u/166021253?v=4" height="120"></a> | <a href="https://github.com/LosadaT"><img src="https://avatars.githubusercontent.com/u/99215889?v=4" height="120"></a> | <a href="https://github.com/OliveiraRNeves"><img src="https://avatars.githubusercontent.com/u/73305741?v=4" height="120"></a> | <a href="https://github.com/hyauss"><img src="https://avatars.githubusercontent.com/u/69730958?v=4" height="120"></a> |

## Roadmap / Limitações conhecidas

- [ ] Habilitar a coleta do nome do usuário no primeiro acesso (`OnboardingView` existe no código, mas está comentada; hoje a identidade é criada com nome vazio)
- [ ] Cadastrar produtos reais no `StoreKitProducts.storekit` para um eventual plano premium (grupo de assinatura "Premium" já existe, mas vazio)
- [ ] Substituir os IDs de teste do Google Mobile Ads pelos IDs de produção antes da publicação
- [ ] Remover código de protótipo não utilizado no fluxo principal (`ContentView 2.swift`, `AptabaseTesteView.swift`)
- [ ] Implementar os testes unitários e de UI que hoje existem apenas como rascunho comentado (CloudKit, login, notificações push)
- [ ] Adicionar testes de UI reais cobrindo a criação de grupo, o convite por link e a votação de atividades

## Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
