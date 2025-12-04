/// @description Configuração Visual

y_start = y;
timer = 0;

// --- SELETOR AUTOMÁTICO DE SPRITE ---
// Baseado na variável 'tipo_habilidade' que você define na Sala
switch(tipo_habilidade) {
    
    case "dash":
        sprite_index = spr_item_dash; 
        image_index = 0; // Garante que comece do frame 0
        break;
        
    case "pulo_duplo":
        sprite_index = spr_item_pulo_duplo;
        image_index = 0;
        break;
        
    case "wall_slide":
        sprite_index = spr_item_wall_slide;
        image_index = 0;
        break;
        
    case "espada":
        sprite_index = spr_item_espada;
        image_index = 0;
        break;
        
    // Caso padrão (se você esquecer de configurar ou errar o nome)
    default:
        // sprite_index = spr_item_generico; 
        show_debug_message("AVISO: PowerUp com tipo desconhecido: " + string(tipo_habilidade));
        break;
}