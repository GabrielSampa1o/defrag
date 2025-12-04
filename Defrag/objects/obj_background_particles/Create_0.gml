/// @description Sistema de Partículas (Dados Flutuantes)

// 1. Cria o Sistema
global.part_sys = part_system_create();
part_system_depth(global.part_sys, 200); // Garante que fica bem no fundo

// 2. Cria o Tipo de Partícula "Pixel de Dado"
global.part_data = part_type_create();

// Forma: Um pixel quadrado simples
part_type_shape(global.part_data, pt_shape_pixel);

// Tamanho: Pequeno e variado
part_type_size(global.part_data, 1, 2, 0, 0);

// Cor: Tons de Verde Tech (do escuro ao neon)
part_type_color3(global.part_data, c_dkgray, c_teal, c_lime);

// Transparência: Começa invisível, aparece, e some (Fade in/out)
part_type_alpha3(global.part_data, 0, 0.6, 0);

// Movimento: Sobe devagar (como dados sendo processados)
part_type_speed(global.part_data, 0.5, 1.5, 0, 0);
part_type_direction(global.part_data, 90, 90, 0, 2); // 90 graus = Cima

// Vida: Dura bastante tempo na tela (3 a 6 segundos)
part_type_life(global.part_data, 180, 360);

// 3. Emissor (Onde as partículas nascem)
// Vamos fazer elas nascerem na tela toda, mas principalmente em baixo
emitter = part_emitter_create(global.part_sys);