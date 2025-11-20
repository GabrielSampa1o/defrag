 
//Sistema de colisão e movimentacao

// Seu código original:
 var _velh = sign(velh); 
 var _velv = sign(velv); 

// --- Colisão Horizontal ---
repeat(abs(velh)) {
    if (place_meeting(x + _velh, y, obj_bloco)) {
        velh = 0;
        break;
    }
    x += _velh; // Movimento
}

// --- Colisão Vertical ---
repeat(abs(velv)) {
    if (place_meeting(x, y + _velv, obj_bloco)) {
        velv = 0;
        break;
    }
    y += _velv; // Movimento
}
