# 🖱️ Logitech G-Hub - Smart Recoil Control (LUA Project with QA Engineering)

Este repositório contém um script inteligente de controle de recuo vertical desenvolvido em **LUA** para o ecossistema Logitech G-Hub. O projeto simula o ciclo de desenvolvimento completo de uma funcionalidade, utilizando **Metodologias Ágeis (Trello)**, **Testes Estáticos (Revisão de Código)** e **Testes Dinâmicos de Caixa-Preta**.

---

## 🎯 Objetivo do Projeto
Prover uma compensação de recuo estável e configurável para jogadores competitivos, com garantia de integridade de software (Thread-Safe), utilizando uma barreira de segurança de estados física do mouse.

---

## 🛠️ Funcionalidades Desenvolvidas
*   **Sistema de Inicialização Segura:** O script inicia ativo com o **Modo Normal (Fogo 🔥)** pronto para uso.
*   **Modo Alternativo Leve (Botão 8):** Alterna o recuo para uma compensação mais suave, ideal para armas de menor dispersão ou longa distância (Feedback visual: `Modo Alternativo ❄️`).
*   **Chave Geral ON/OFF (Botão 9):** Desativa ou ativa todo o sistema instantaneamente.
*   **Bloqueio de Estado Desligado (Safety Lock):** Se o sistema estiver desligado, comandos de troca de modo (Botão 8) são totalmente ignorados para evitar ativações acidentais.

---

## 🧪 Engenharia de QA & Processo de Testes

O grande diferencial deste projeto é a aplicação rigorosa de conceitos de QA ao longo de todo o seu ciclo de vida.

### 1. Gestão Ágil e Rastreabilidade (Trello)
O ciclo de desenvolvimento foi gerenciado em um quadro Kanban, conectando requisitos de negócio, critérios de aceite e bugs encontrados:
*   **`[US-01]` Controle de Recuo Inteligente:** Requisitos de negócio mapeados a partir do ponto de vista e das necessidades do usuário final.
*   **`[BUG-01]` Falha de retenção de estado no segundo clique de mira rápida (Race Condition):** Bug físico que travava o movimento do mouse na segunda tentativa de clique rápido (resolvido com transição para loop `while`).
*   **`[FEAT-01]` Implementação do Modo de Recuo Alternativo Leve (Botão 8):** Adição de um perfil de compensação vertical reduzido, ideal para armas de menor calibre.
*   **`[REF-01]` Refatoração para Loop Síncrono e Mecanismo de Reset de Estado (LUA):** Reestruturação completa do fluxo de repetição do script para garantir estabilidade e eliminar concorrência.
*   **`[BUG-02]` Falha de restauração de estado anterior ao sair do Modo Alternativo:** Correção lógica para memorizar e restaurar o estado original do recuo padrão ao desativar o modo leve.
*   **`[BUG-03]` Desvio de trajetória no recuo alternativo (Compensação Horizontal ausente):** Ajuste fino das coordenadas de movimento horizontal (X) no modo leve para manter a suavidade padrão.
*   **`[FEAT-02]` Sistema de Feedback Visual por Emojis no Console de Log:** Integração de logs limpos e iconizados com emojis para indicar as mudanças de estado físico do script.
*   **`[REFACTOR-02]` Remoção de Dead Code (Variável Rapidfire):** Limpeza de variáveis e lógicas obsoletas que não faziam parte do escopo de uso do software.
*   **`[REFACTOR-03]` Eliminação de Logs de Eventos Gerais (Console Clean):** Desativação de logs redundantes do mouse que poluíam o console do G-Hub a cada clique físico.
*   **`[BUG-04]` Botão 9 falha em desligar o script se o Modo Alternativo estiver ativo:** Correção do bug herdado onde o botão de desligar apenas revertia para o modo normal em vez de cessar todo o sistema.
*   **`[BUG-05]` Botão 8 permite bypass e ativa o recuo com o sistema desligado:** Implementação de trava de segurança para impedir que o perfil alternativo fosse ativado se a chave geral estivesse em `OFF`.

### 2. Evolução de Arquitetura e Soluções (Thread-Safe)

Para sanar todas as falhas de concorrência e vazamento de estado de cliques rápidos, a versão final utiliza um controle rígido baseado na variável `system_on`:

```lua
-- Garante que o botão 8 só responda se o sistema estiver ligado
if event == "MOUSE_BUTTON_PRESSED" and arg == 8 then
    if system_on then
        light_recoil = not light_recoil
        -- ... lógica de alternância
    end
end
```
## 📋 Cenários de Teste Aplicados (Sanity & Regressão)

| ID do Cenário | Descrição do Teste | Tipo de Teste | Resultado Esperado | Status |
| :---: | :--- | :---: | :--- | :---: |
| **TC-01** | Pressionar Botão 3 + Botão 1 consecutivamente (Cliques Rápidos). | Sanidade | O mouse compensa o recuo perfeitamente e para o movimento imediatamente ao soltar. | **PASSOU** ✅ |
| **TC-02** | Desativar o script via Botão 9 e tentar atirar mirando. | Funcional | O recuo não deve ser compensado. O mouse deve se comportar normalmente. | **PASSOU** ✅ |
| **TC-03** | Alternar para Modo Alternativo (Botão 8) e atirar. | Funcional | O recuo deve compensar de forma leve (`Modo Alternativo ❄️`). | **PASSOU** ✅ |
| **TC-04** | Desativar o script (Botão 9) enquanto estiver no Modo Alternativo (Botão 8). | Regressão | O script deve desligar completamente (Logs: `OFF 🔴`) em vez de apenas voltar para o modo normal. | **PASSOU** ✅ |
| **TC-05** | Pressionar o Botão 8 com o sistema desligado (Botão 9 em OFF). | Caixa-Preta / Transição | O comando do Botão 8 deve ser ignorado. O script deve continuar 100% inativo. | **PASSOU** ✅ |
| **TC-06** | Alternar do Modo Alternativo de volta para o Modo Normal (Botão 8). | Regressão / Funcional | O sistema deve restaurar com sucesso o estado do recuo anterior e reativar a oscilação horizontal de peso 4 (Modo Normal 🔥). | PASSOU ✅ |
---

## 💻 Como Utilizar este Script

Siga o passo a passo abaixo para carregar o script com segurança no seu software:

1. Abra o software **Logitech G-Hub**.
2. Na tela inicial, clique na barra de **Perfis** no topo para abrir a janela de **All Games & Apps** (Todos os Jogos e Aplicativos).
3. Selecione o jogo desejado (ou o perfil **Desktop**) e, no cartão do perfil correspondente (ex: **Default**), clique no ícone de **três pontos verticais (`⋮`)**.
4. No menu suspenso que aparecer, clique em **Create LUA Script** (Criar Script LUA) para abrir o editor de programação.
5. No editor que abrir, delete qualquer código padrão existente e cole o conteúdo do arquivo `script.lua` deste repositório.
6. Salve o script pressionando as teclas **`Ctrl + S`** no seu teclado.
7. Mantenha o console do editor aberto para acompanhar em tempo real os logs visuais com emojis durante a gameplay.
8. Lembre-se de que você precisa ter um mouse Logitech para conseguir utilizar e testar este script!
