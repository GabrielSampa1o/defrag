dano = 5; // Dano base da explosão
aplicar_dano = ds_list_create(); // Lista para garantir que só dá dano 1 vez por entidade

// Opcional: Efeitos visuais
image_alpha = 0.5; // Só para debug
//alarm[0] = 20; // A explosão dura apenas alguns frames (ex: 10 frames)