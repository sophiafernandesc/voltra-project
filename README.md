# VOLTRA⚡

> Aplicativo de gestão inteligente para veículos elétricos, híbridos e a combustão – com foco em mobilidade, segurança e eficiência energética.

[![GitHub Repo](https://img.shields.io/badge/GitHub-SophiaCFernandes/Voltra-blue?logo=github)](https://github.com/SophiaCFernandes/Voltra/edit/main/README.md)

---

## 📱 Visão Geral

**VOLTRA** é um aplicativo mobile multiplataforma (com foco inicial em Android) projetado para melhorar a experiência de motoristas em diferentes frentes:  
- Carregamento de veículos elétricos  
- Avaliação de combustível para veículos a combustão  
- Monitoramento e segurança veicular

O projeto está sendo desenvolvido como parte da disciplina de **Desenvolvimento Mobile**, mas com a ambição técnica de ultrapassar o tradicional MVP acadêmico genérico.

---

## 🎯 Objetivos

- Otimizar o acesso a estações de carregamento elétrico em Belo Horizonte através de uma **fila virtual inteligente**
- Ajudar usuários a **identificar combustível de baixa qualidade** e evitar prejuízos mecânicos
- Oferecer um sistema de **rastreamento e segurança veicular** com monitoramento em tempo real
- Centralizar múltiplas necessidades do motorista em uma única interface intuitiva

---

## 👥 Público-Alvo

Motoristas brasileiros que:
- Utilizam veículos elétricos ou híbridos e enfrentam dificuldades para encontrar estações de carregamento
- Desejam monitorar o desempenho de combustível dos seus veículos a combustão
- Buscam mais segurança e controle sobre a localização e uso dos seus carros

---

## ⚙️ Funcionalidades

### 🔋 Veículos Elétricos e Híbridos

- **Fila Virtual para Carregamento**  
  Através da leitura de um QR Code na estação, o motorista entra em uma fila digital e pode monitorar o tempo estimado até sua vez.

- **Mapa Interativo (Mapbox API)**  
  Exibição das estações de carregamento em BH, com informações em tempo real sobre disponibilidade e status.

- **Feedback da Estação**  
  Sistema de avaliação das estações com base na experiência dos usuários.

---

### ⛽ Veículos a Combustão

- **Avaliação da Qualidade de Combustível**  
  Histórico de abastecimento e desempenho, utilizando sensores e análise dos dados de consumo (simulação via Arduino com potenciômetros).

- **Conformidade Legal**  
  Indicação se o combustível atende os padrões da legislação brasileira.

---

### 🔐 Segurança Veicular

- **Localização em Tempo Real**  
  Monitoramento contínuo da posição do veículo.

- **Histórico de Rotas**  
  Registro completo de trajetos realizados.

- **Notificações de Segurança**  
  Alertas por push em caso de movimentação não autorizada ou ignição indevida.

- **Compartilhamento de Acesso**  
  Possibilidade de familiares ou outros usuários acompanharem o veículo.

---

## 🖼️ Interface (UI/UX)

Repositório Figma: https://www.figma.com/design/FsyTdu0DmyYDz0sEgpbS6h/Voltra?node-id=28-159&p=f&t=LWggTVPleiLZkM7w-0
### Estrutura de Telas:
- **Tela de Boas-Vindas / Onboarding**
- **Login e Cadastro de Usuário**
- **Tela Principal (Mapa Interativo)**
- **Fila Virtual de Carregamento**
- **Histórico de Trajetos e Abastecimentos**
- **Perfil e Configurações do Veículo**
- **Central de Segurança e Notificações**

---

## 🛠️ Tecnologias e Ferramentas

- **Figma** – Prototipação e UI Design  
- **Flutter** (a definir) – Desenvolvimento mobile  
- **Mapbox API** – Geolocalização e visualização de estações  
- **Firebase** – Autenticação, notificações e backend básico  
- **ESP32+ Sensores** – Simulação da análise de combustível

---


## 📎 Contribuição

Como este é um projeto acadêmico em grupo, colaborações são bem-vindas. Se você faz parte do time e quer adicionar sua ideia ao caos organizado que chamamos de "app", abra uma issue ou envie um pull request.

---

## 🔌 Considerações Finais

**VOLTRA** é uma tentativa sincera de unir mobilidade, sustentabilidade e segurança em uma solução única. Mesmo com todas as opiniões divergentes, brainstorms que deveriam ter sido emails e debates sobre o nome do projeto que ninguém venceu, estamos comprometidos com a entrega de um app funcional, intuitivo e, acima de tudo, útil.
