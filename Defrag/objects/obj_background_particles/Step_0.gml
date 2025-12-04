/// @description Atualiza Posição e Criação

// Pega a posição da câmera
var _cx = camera_get_view_x(view_camera[0]);
var _cy = camera_get_view_y(view_camera[0]);
var _cw = camera_get_view_width(view_camera[0]);
var _ch = camera_get_view_height(view_camera[0]);

// Define a região onde as partículas podem nascer (Toda a tela + bordas)
part_emitter_region(global.part_sys, emitter, _cx - 100, _cx + _cw + 100, _cy + _ch, _cy + _ch + 50, ps_shape_rectangle, ps_distr_linear);

// Cria 1 partícula a cada frame (ajuste para mais ou menos densidade)
// Como o jogo roda a 60fps, isso enche a tela rápido.
part_emitter_burst(global.part_sys, emitter, global.part_data, 1);

// Opcional: Criar algumas aleatórias no meio da tela para não ficar vazio
if (random(100) < 5) { // 5% de chance
    part_particles_create(global.part_sys, _cx + random(_cw), _cy + random(_ch), global.part_data, 1);
}