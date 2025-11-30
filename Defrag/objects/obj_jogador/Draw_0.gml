/// @description Insert description here
// You can write your code in this editor

/// @description Desenha o Sprite Separado da Física

// Lógica para decidir para onde olhar VISUALMENTE
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

// Desenha o personagem
draw_sprite_ext(
    sprite_index, 
    image_index, 
    x, 
    y, 
    _olhar,        // AQUI ESTÁ O SEGREDO
    image_yscale, 
    image_angle, 
    c_white, 
    image_alpha
);





