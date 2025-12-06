/// @description Desenha: Imagem + Cor + Partículas

var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

// =========================================================
// 1. IMAGEM DE FUNDO (COM PARALLAX)
// =========================================================
// O Parallax faz a imagem mover mais devagar que a câmera, dando profundidade.
// 0.9 = Fundo muito longe. 0.5 = Fundo médio.

var _fator_parallax = 0.8; 
var _pos_x = _cx * _fator_parallax;
var _pos_y = _cy * _fator_parallax;

// Desenha o sprite repetido infinitamente na posição calculada
draw_sprite_tiled(spr_bg_padrao, 0, _pos_x, _pos_y);


// =========================================================
// 2. FILTRO DE COR (DEGRADÊ)
// =========================================================
// Desenhamos o degradê por cima da imagem, mas TRANSPARENTE.
// Isso serve para "pintar" a imagem com as cores do tema (Verde/Azul).

var col_top = make_color_rgb(5, 10, 20);   // Preto Azulado
var col_bot = make_color_rgb(20, 40, 50);  // Verde Petróleo

// Define transparência (0.8 significa que vê 20% da imagem atrás)
// Ajuste para mais ou menos visibilidade da textura
draw_set_alpha(0.85); 

draw_rectangle_color(_cx, _cy, _cx + _cw, _cy + _ch, col_top, col_top, col_bot, col_bot, false);

// Volta a opacidade para o normal para não estragar as partículas
draw_set_alpha(1);


// =========================================================
// 3. PARTÍCULAS (SYSTEM)
// =========================================================
// O sistema de partículas desenha-se sozinho aqui por cima de tudo
// (Pois está configurado na layer ou via part_system_drawit se precisar)