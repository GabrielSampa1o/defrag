/// @description Insert description here
// You can write your code in this editor

/// @description Inicializa Globais do Jogo

// Habilidades (Começam bloqueadas)
global.tem_dash = false;
global.tem_pulo_duplo = false;
global.tem_wall_slide = false;
global.tem_espada = false;

// Estado do Jogo (Para pausar quando pegar item)
global.game_state = "jogando"; // ou "pausado"

global.vel_mult = 1;

game_over = false;

valor = 0;
contador = 0;

/// @description Variáveis de Controle de Fim de Jogo

show_thanks_message = false;
message_timer = 0;
