/// @description Desenha o Sprite Separado da Física

// 1. LÓGICA VISUAL (WALL SLIDE FIX)
// Mantemos essa lógica para o personagem não travar na parede
var _olhar = 1;

if (estado == "wall_slide") {
    // No wall slide, usamos a variável que definimos lá (xscale_visual)
    _olhar = xscale_visual;
} 
else if (velh != 0) {
    // Se movendo, olha para a direção do movimento
    _olhar = sign(velh);
    // Salva essa direção como padrão para quando ficar parado
    xscale_visual = _olhar; 
} else {
    // Parado, mantém a última direção
    _olhar = xscale_visual;
}

// 2. DESENHO FINAL
draw_sprite_ext(
    sprite_index, 
    image_index, 
    x, 
    y, 
    _olhar,        // Direção Visual
    image_yscale, 
    image_angle, 
    image_blend,   // [MUDANÇA] Usar image_blend permite mudar cor (vermelho/cinza)
    image_alpha    // [IMPORTANTE] Permite a transparência (piscar)
);