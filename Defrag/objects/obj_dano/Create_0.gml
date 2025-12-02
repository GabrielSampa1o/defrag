/// @description Inicialização da Hitbox

dano = 0;
pai = noone;       // Quem criou este dano (Player ou Inimigo)
image_alpha = 1;   // Use 0 no jogo final para ficar invisível
morrer = true;     // Se true, destrói no final do frame

// --- PROPRIEDADES DE IMPACTO (Valores Padrão) ---
// O objeto que cria o dano pode sobrescrever isso depois
forca_knockback = 10;  // Força que empurra a vítima
forca_recuo = 0;       // Força que empurra quem bateu (se for player)
tremor_hit = 2;        // Força do screenshake

// --- LISTAS DE COLISÃO ---
// Lista para lembrar quem já apanhou deste ataque específico
// Isso impede que um ataque que dura 1 segundo tire vida 60 vezes
lista_acertados = ds_list_create();