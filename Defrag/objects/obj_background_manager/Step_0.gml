/// @description Emissor de Partículas

// Pega a câmera para saber onde criar
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

// Define região (Tela toda + margem em baixo para nascerem antes de entrar na tela)
part_emitter_region(global.part_sys, emitter, _cx, _cx + _cw, _cy + _ch, _cy + _ch + 50, ps_shape_rectangle, ps_distr_linear);

// Cria 1 partícula por frame (Aumente o número se quiser mais "poeira")
part_emitter_stream(global.part_sys, emitter, global.part_data, 1);