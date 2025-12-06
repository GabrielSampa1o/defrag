/// @description Setup do Sistema

// 1. Sistema de Partículas
global.part_sys = part_system_create();
part_system_depth(global.part_sys, 200); // Fica bem no fundo

// 2. Tipo de Partícula "Pixel de Dado"
global.part_data = part_type_create();
part_type_shape(global.part_data, pt_shape_pixel);
part_type_size(global.part_data, 1, 2, 0, 0);
part_type_color3(global.part_data, c_dkgray, c_teal, c_lime); // Cores Tech
part_type_alpha3(global.part_data, 0, 0.6, 0); // Fade in/out
part_type_speed(global.part_data, 0.5, 1.5, 0, 0); // Sobe devagar
part_type_direction(global.part_data, 90, 90, 0, 2); // 90 = Cima
part_type_life(global.part_data, 180, 360); // Vive bastante

// 3. Emissor
emitter = part_emitter_create(global.part_sys);