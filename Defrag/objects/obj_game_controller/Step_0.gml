/// @description Gerenciamento de Fim de Jogo e Velocidade (CONSOLIDADO E CORRIGIDO)

// --- Prioridade 1: VITÓRIA FINAL (Mostra Mensagem) ---
if (show_thanks_message) {
    
    // Zera toda a velocidade e pausa o jogo imediatamente
    global.vel_mult = 0;
    global.game_state = "pausado";
    
    message_timer++;
    
    var input_reset = keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(0, gp_start);
    
    if (message_timer > 60 && (message_timer > 300 || input_reset)) { 
    // Garante que o usuário viu a mensagem por no mínimo 1 segundo (60 frames)
    
    // Antes de reiniciar, reativa tudo para evitar erros de inicialização
    instance_activate_all(); 
    game_restart(); 
}
}

// --- Prioridade 2: MORTE/GAME OVER (Sem Mensagem de Agradecimento) ---
// Se game_over for true, mas show_thanks_message for false (morte normal)
else if (game_over) {
    
    // Aplica o Slow Motion para o player ver a animação de morte
    global.vel_mult = 0.5; 
    global.game_state = "jogando"; 
    
    // Lógica de espera para a animação da tela de morte terminar (2 segundos, por exemplo)
    // O seu código de Draw GUI já tem a lógica de animação 'valor', então é só esperar.
    
}

// --- Prioridade 3: JOGO ATIVO (Padrão) ---
else {
    global.vel_mult = 1; // Velocidade normal (100%)
    global.game_state = "jogando";
}