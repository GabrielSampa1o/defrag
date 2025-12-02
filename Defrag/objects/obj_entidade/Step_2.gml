// =========================================================
// SISTEMA DE COLISÃO E MOVIMENTO
// =========================================================

// Aplica inércia extra se houver
var velh_final = velh + mid_velh;
var _dir_h = sign(velh_final);

// --- COLISÃO HORIZONTAL ---
repeat(abs(velh_final)) {
    
    // Verifica APENAS Parede (obj_bloco)
    if (place_meeting(x + _dir_h, y, obj_bloco)) {
        velh = 0;
        mid_velh = 0;
        break;
    }
    
    // [REMOVIDO] A verificação de obj_inimigo_pai foi apagada.
    // Agora você passa por dentro dele (o sistema de dano vai detectar o toque separadamente).
    
    x += _dir_h;
}

// --- COLISÃO VERTICAL ---
var _dir_v = sign(velv);
repeat(abs(velv)) {
    
    // Verifica APENAS Parede (obj_bloco)
    if (place_meeting(x, y + _dir_v, obj_bloco)) {
        velv = 0;
        break;
    }
    
    // [REMOVIDO] A verificação de obj_inimigo_pai foi apagada.
    // Você não consegue mais pisar na cabeça do inimigo como se fosse chão.
    
    y += _dir_v;
}