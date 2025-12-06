/// @description Fundo Degradê

var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

// Cores do tema (Escuro em cima, um pouco mais claro em baixo)
var col_top = make_color_rgb(5, 10, 15);   // Quase preto
var col_bot = make_color_rgb(20, 40, 50);  // Verde petróleo escuro

// Desenha o retângulo degradê
draw_rectangle_color(_cx, _cy, _cx + _cw, _cy + _ch, col_top, col_top, col_bot, col_bot, false);