
// Gravidade
var chao = place_meeting(x, y + 1, obj_bloco);
if (!chao) velv += GRAVIDADE * massa * global.vel_mult;

switch(estado){
    
    case "parado":
        // Chama o método genérico
        estado_parado(spr_slime_idle);
        // Verifica ataque específico do slime
        scr_verificar_ataque_melee(obj_jogador, 30, 20, image_xscale);
        break;
        
    case "movendo":
        // Chama método genérico (Sprite, Velocidade, Tempo)
        estado_movendo(spr_slime_idle, max_velh, 200);
        break;
        
    case "perseguindo":
        // Sprite, Velocidade, Distância Ataque, Distância Desiste
        estado_perseguindo(spr_slime_idle, max_velh * 1.5, 30, 300);
        break;
        
    case "atacando":
        atacando(spr_slime_attack, 2, 5, 20, -10);
        break;
        
    case "hit":
        leva_dano(spr_slime_hit, image_number-1);
        // Se acabou hit, persegue
        if (image_index >= image_number - 1 && vida_atual > 0) estado = "perseguindo";
        break;
        
    case "morto":
        morrendo(spr_slime_death);
        break;
}

event_inherited(); 
