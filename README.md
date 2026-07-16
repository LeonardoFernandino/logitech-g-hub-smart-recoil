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
*   **`[US-01]` Controle de Recuo Inteligente:** Requisitos de negócio do ponto de vista do usuário.
*   **`[BUG-01]` Falha de retenção de estado (Race Condition):** Bug físico que travava a mira no segundo clique de mira rápida (resolvido com loop `while`).
*   **`[BUG-02]` Falha de Desligamento no Modo Alternativo:** Bug onde o Botão 9 apenas alternava para o modo normal em vez de desligar o sistema completo.
*   **`[BUG-03]` Bypass de Inicialização (Ativação Involuntária):** Bug onde o Botão 8 ativava o recuo mesmo com o sistema desligado no Botão 9.

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

## 📋 Cenários de Teste Aplicados (Sanity & Regressão)

| ID do Cenário | Descrição do Teste | Tipo de Teste | Resultado Esperado | Status |
| :---: | :--- | :---: | :--- | :---: |
| **TC-01** | Pressionar Botão 3 + Botão 1 consecutivamente (Cliques Rápidos). | Sanidade | O mouse compensa o recuo perfeitamente e para o movimento imediatamente ao soltar. | **PASSOU** ✅ |
| **TC-02** | Desativar o script via Botão 9 e tentar atirar mirando. | Funcional | O recuo não deve ser compensado. O mouse deve se comportar normalmente. | **PASSOU** ✅ |
| **TC-03** | Alternar para Modo Alternativo (Botão 8) e atirar. | Funcional | O recuo deve compensar de forma leve (`Modo Alternativo ❄️`). | **PASSOU** ✅ |
| **TC-04** | Desativar o script (Botão 9) enquanto estiver no Modo Alternativo (Botão 8). | Regressão | O script deve desligar completamente (Logs: `OFF 🔴`) em vez de apenas voltar para o modo normal. | **PASSOU** ✅ |
| **TC-05** | Pressionar o Botão 8 com o sistema desligado (Botão 9 em OFF). | Caixa-Preta / Transição | O comando do Botão 8 deve ser ignorado. O script deve continuar 100% inativo. | **PASSOU** ✅ |

---

## 💻 Como Utilizar este Script

1. Abra o software **Logitech G-Hub**.
2. Vá no menu de **Perfis** do jogo desejado e clique em **Scripting (Programação)**.
3. Crie um novo script e cole o código do arquivo `script.lua` deste repositório.
4. Salve (`Ctrl + S`) e mantenha o console de script aberto para visualizar os logs de troca de modos e ativação.
