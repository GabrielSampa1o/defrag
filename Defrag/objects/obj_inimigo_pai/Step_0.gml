/// @description Física e Colisão Mestre


// --- PAUSA O JOGO (IA) ---
if (global.game_state == "pausado") {
    image_speed = 0;
    exit; // Inimigo para de pensar e de andar
}
image_speed = 1;

// ... Resto do seu código normal ...

// 1. MORTE (Verificação de segurança)
if (vida_atual <= 0 && estado != "morto") {
    estado = "morto";
    velh = 0;
    image_index = 0;
}

// 2. SISTEMA DE COLISÃO (Obrigatório ser depois da IA do filho)

// --- Colisão Horizontal ---
// Usamos uma variável temporária para não alterar o velh durante o loop
var _velh_temp = velh;
var _dir_h = sign(_velh_temp);

repeat(abs(_velh_temp)) {
    
    // Verifica Parede OU Limite
    if (place_meeting(x + _dir_h, y, obj_bloco) || place_meeting(x + _dir_h, y, obj_limite_inimigo)) {
        
        velh = 0; // Trava a velocidade real
        
        // Se estiver em PATRULHA, vira
        if (mid_velh != 0) {
            mid_velh *= -1;
            image_xscale = sign(mid_velh);
        }
        
        break; // Para de mover
    }
    
    x += _dir_h;
}

// --- Colisão Vertical ---
var _velv_temp = velv;
var _dir_v = sign(_velv_temp);

repeat(abs(_velv_temp)) {
    if (place_meeting(x, y + _dir_v, obj_bloco)) {
        velv = 0;
        break;
    }
    y += _dir_v;
}