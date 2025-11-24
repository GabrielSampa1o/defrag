 
//Sistema de colisão e movimentacao

var _velh = sign(velh); // Direção horizontal (-1, 0 ou 1)
var _velv = sign(velv); // Direção vertical (-1, 0 ou 1)

// --- Colisão Horizontal ---
// Repete o loop para cada pixel de movimento na horizontal
repeat(abs(velh)) {
    // Se for colidir com um bloco no próximo pixel...
    if (place_meeting(x + _velh, y, obj_bloco)) {
        velh = 0; // Para o movimento horizontal
        break;    // Sai do loop
    }
    // Se não houver colisão, move um pixel na direção correta
    x += _velh; 
}
// --- Colisão Vertical ---
// Repete o loop para cada pixel de movimento na vertical
repeat(abs(velv)) {
    // Se for colidir com um bloco no próximo pixel...
    if (place_meeting(x, y + _velv, obj_bloco)) {
        velv = 0; // Para o movimento vertical
        break;    // Sai do loop
    }
    // Se não houver colisão, move um pixel na direção correta
    y += _velv; 

}
