-- O script já inicia com o sistema e o Recuo Padrão ATIVADOS por padrão
local system_on = true
local recoil = true
local light_recoil = false 
local recoil_running = false 

function OnEvent(event, arg)

    -- Ativação do perfil
    if event == "PROFILE_ACTIVATED" then
        EnablePrimaryMouseButtonEvents(true)
    end

    -- Alternar/Desligar Recuo Geral (Botão 9)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 9 then
        system_on = not system_on -- Liga ou desliga o sistema geral
        
        if system_on then
            -- Ao ligar o sistema, sempre força o Modo Normal
            recoil = true
            light_recoil = false
            OutputLogMessage("Recoil Padrao: ON 🟢\n")
        else
            -- Desliga o sistema e todas as variáveis de recuo
            recoil = false
            light_recoil = false
            OutputLogMessage("Recoil Padrao: OFF 🔴\n")
        end
    end

    -- Alternar para o Modo Alternativo (Botão 8)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 8 then
        -- BARREIRA DE SEGURANÇA: Só aceita o comando se o sistema geral estiver LIGADO
        if system_on then
            light_recoil = not light_recoil
            if light_recoil then
                recoil = false
                OutputLogMessage("Modo Alternativo ❄️\n")
            else
                recoil = true
                OutputLogMessage("Modo Normal 🔥\n")
            end
        end
    end

    -- Execução do Recuo (Botão 1)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 1 then
        -- Só executa se o sistema estiver ativo E um dos modos estiver selecionado
        if system_on and (recoil or light_recoil) and IsMouseButtonPressed(3) then
            recoil_running = true
            
            while IsMouseButtonPressed(1) and IsMouseButtonPressed(3) and recoil_running do
                if recoil then
                    -- Recuo Padrão
                    MoveMouseRelative(-1, 8)
                    Sleep(15)
                    MoveMouseRelative(1, 8)
                    Sleep(15)
                elseif light_recoil then
                    -- Recuo Alternativo Leve
                    MoveMouseRelative(-1, 4)
                    Sleep(15)
                    MoveMouseRelative(1, 4)
                    Sleep(15)
                end
                
                if not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3) then
                    recoil_running = false
                end
            end
            
            recoil_running = false
        end
    end

    -- Forçar a limpeza de estado se qualquer um dos botões principais for solto
    if event == "MOUSE_BUTTON_RELEASED" and (arg == 1 or arg == 3) then
        recoil_running = false
    end
end
