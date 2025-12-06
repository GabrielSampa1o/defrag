/// @description Coletar a Espada

// 1. Desbloqueia a habilidade globalmente
global.tem_espada = true;

// 2. Já equipa a espada automaticamente para o jogador sentir o poder
other.arma_atual = "espada";

// 3. Feedback (Som e Efeitos)
// audio_play_sound(snd_item_get, 1, false);

// 4. Pausa dramática ou Texto (Estilo Zelda/Metroid)
// Aqui você pode criar um objeto de caixa de texto explicando
show_debug_message("VOCÊ OBTEVE A LÂMINA DE LUZ!");

// 5. Destrói o item para ele não ser pego de novo
instance_destroy();