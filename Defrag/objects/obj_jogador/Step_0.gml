/// @description Lógica Principal (Input, Estados)

// =========================================================
// 1. CAPTURA DE INPUTS (TECLADO + GAMEPAD)
// =========================================================
var direita, esquerda, pulo, dash, pulo_solto;
var chao = place_meeting(x, y + 1, obj_bloco); 

// Movimento Horizontal (Teclado OU Analógico)
direita = keyboard_check(ord("D")) || gamepad_button_check(gamepad_slot, gp_padr) || (gamepad_axis_value(gamepad_slot, gp_axislh) > 0.2);
esquerda = keyboard_check(ord("A")) || gamepad_button_check(gamepad_slot, gp_padl) || (gamepad_axis_value(gamepad_slot, gp_axislh) < -0.2);

// Ações
pulo = keyboard_check_pressed(ord("K")) || gamepad_button_check_pressed(gamepad_slot, gp_face1);
dash = keyboard_check_pressed(ord("L")) || gamepad_button_check_pressed(gamepad_slot, gp_face2); 

// Pulo Solto (Para controlar altura)
pulo_solto = keyboard_check_released(ord("K")) || gamepad_button_check_released(gamepad_slot, gp_face1);

// =========================================================
// 2. LÓGICA DE TEMPORIZADORES (GAME FEEL)
// =========================================================

// Diminuindo o dash timer
if(dash_timer > 0) dash_timer--;
if(wall_jump_delay > 0) wall_jump_delay--; // Diminui a trava



// Coyote Time
if (chao) {
    pulos_restantes = max_pulos;
    coyote_timer = coyote_max;
	
	//regarrega o dash aereo
	dash_aereo_disponivel = true;
} else {
    // Se caiu sem pular, perde o primeiro pulo
    if (coyote_timer <= 0 && pulos_restantes == max_pulos) {
        pulos_restantes = max_pulos - 1;
    }
    if (coyote_timer > 0) coyote_timer--;
}

// Jump Buffer
if (pulo) {
    buffer_timer = buffer_max;
}
if (buffer_timer > 0) buffer_timer--;

// =========================================================
// 3. CÁLCULO DE MOVIMENTO
// =========================================================

// SE a trava estiver ativa, fingimos que o jogador não está apertando nada
if (wall_jump_delay > 0) {
    direita = 0;
    esquerda = 0;
}

// Velocidade base
velh = (direita - esquerda) * max_velh;

// Virar o sprite
if (velh != 0) image_xscale = sign(velh);

// Gravidade
if(!chao){
    if(velv < max_velv * 2){
        velv += GRAVIDADE * massa;
    }    
    // Pulo Variável (Corta subida se soltar botão)
    if (pulo_solto && velv < 0) {
        velv *= 0.5; 
    }
}

// Atrito no ar (diminui a inércia do wall jump com o tempo)
mid_velh = lerp(mid_velh, 0, 0.08); // O 0.08 define quão rápido a inércia morre


// =========================================================
// 4. MÁQUINA DE ESTADOS
// =========================================================

switch(estado){
    
    #region parado
    case "parado":{
        mid_velh = 0;
        sprite_index = spr_jogador_parado;
        
        // PULAR (Buffer + Coyote)
        if (buffer_timer > 0 && coyote_timer > 0) {
            estado = "pulando";
            velv = -max_velv;
            image_index = 0;
            pulos_restantes--; 
            buffer_timer = 0;
            coyote_timer = 0;
        }
        // CAIR
        else if (!chao && coyote_timer <= 0) {
             estado = "pulando"; 
             image_index = 0;
        }
        // MOVER
        else if (velh != 0) {
            estado = "movendo";
        }
        // DASH (Verifica Habilidade)
        else if(dash && dash_timer <= 0 && global.tem_dash){
            estado = "dash";
            image_index = 0;
        }
        break;
    }
    #endregion
    
    #region movendo
    case "movendo":{
        sprite_index = spr_jogador_correndo;
        
        // PULAR
        if (buffer_timer > 0 && coyote_timer > 0) {
            estado = "pulando";
            velv = -max_velv;
            image_index = 0;
            pulos_restantes--;
            buffer_timer = 0;
            coyote_timer = 0;
        }
        // CAIR
        else if (!chao && coyote_timer <= 0) {
             estado = "pulando";
             image_index = 0;
        }
        // PARAR
        else if (abs(velh) < .1) {
            estado = "parado";
            velh = 0;
        }
        // DASH (Verifica Habilidade)
        else if (dash && dash_timer <= 0 && global.tem_dash) {
            estado = "dash";
            image_index = 0;
        }
        break;
    }
    #endregion
	
	#region pulando
    case "pulando":{
        
        // PULO DUPLO
        if (buffer_timer > 0 && pulos_restantes > 0 && global.tem_pulo_duplo) {
            velv = -max_velv; 
            pulos_restantes--; 
            image_index = 0;   
            buffer_timer = 0;
        }
        
        // ANIMAÇÃO
        if(velv > 0) sprite_index = spr_jogador_caindo;
        else sprite_index = spr_jogador_pulando;
        if(image_index >= image_number -1) image_index = image_number -1;
        
        // CHÃO
        if(chao){
            estado = "parado";
            velv = 0;
            dash_aereo_disponivel = true;
            dash_timer = 0; // [CORREÇÃO] Reseta cooldown ao tocar chão
        }
        
        // --- ENTRADA NO WALL SLIDE ---
        var parede_dir = place_meeting(x + 1, y, obj_bloco);
        var parede_esq = place_meeting(x - 1, y, obj_bloco);
        
        // Entra automático (Hollow Knight Style)
        if ((parede_dir || parede_esq) && velv > 0 && global.tem_wall_slide) {
            estado = "wall_slide";
            
            if (parede_dir) dir_parede = 1;
            else dir_parede = -1;
            
            // [CORREÇÃO CRÍTICA]
            // Ao tocar na parede, o dash fica pronto IMEDIATAMENTE.
            dash_timer = 0; 
            dash_aereo_disponivel = true;
			pulos_restantes = max_pulos;
        }
        
        // DASH AÉREO
        if (dash && dash_timer <= 0 && global.tem_dash && dash_aereo_disponivel) {
             estado = "dash";
             image_index = 0;
             dash_aereo_disponivel = false;
        }
        break;
    }
    #endregion

	#region wall_slide
    case "wall_slide":{
        sprite_index = spr_jogador_deslizando; // ou spr_jogador_deslizando
        velh = 0; 
        xscale_visual = -dir_parede; 
        velv = min(velv + 0.5, wall_slide_spd);
        
		// =========================================================
        // 1. DASH DA PAREDE (PRIORIDADE)
        // =========================================================
        if (dash && global.tem_dash) { 
             
             estado = "dash";
             
             // [NOVO] Avisa que este dash nasceu na parede
             veio_da_parede = true;
             
             var dir_oposta = -dir_parede;
             
             // Configura visuais e física
             image_xscale = dir_oposta;
             xscale_visual = dir_oposta;
             mid_velh = dir_oposta * dash_vel; 
             
             // Trava inputs (para não virar de volta)
             wall_jump_delay = room_speed;
             
             x += dir_oposta * 4;
             image_index = 0;
             
             // Garante que o dash aéreo continua disponível para depois
             dash_aereo_disponivel = true; 
             
			 // Define que você tem 1 pulo sobrando (o Pulo Duplo)
             // Se colocasse "max_pulos", você poderia pular 2 vezes depois do dash.
             // Assim fica: Wall Dash -> Pulo Aéreo.
             pulos_restantes = max_pulos - 1;
             break; 
        }
        
        // =========================================================
        // 2. WALL JUMP
        // =========================================================
        else if (buffer_timer > 0) {
            
            velv = -wall_jump_vsp; 
            mid_velh = -dir_parede * wall_jump_hsp; 
            
            // Aqui mantemos o delay curto (10), pois no pulo é bom ter controle rápido
            wall_jump_delay = wall_jump_delay_max;
            
            estado = "pulando";
            buffer_timer = 0; 
            pulos_restantes = max_pulos - 1; 
            
            dash_aereo_disponivel = true;
            dash_timer = 0; 
        }
        
        // =========================================================
        // 3. SAÍDAS
        // =========================================================
        var tem_parede = place_meeting(x + dir_parede, y, obj_bloco);
        
        if (chao) {
            estado = "parado";
            wall_jump_delay = 0; 
            dash_timer = 0;
            dash_aereo_disponivel = true;
            velh = 0;
            mid_velh = 0;
        }
        else if (!tem_parede) {
            estado = "pulando";
        }
        else if ((dir_parede == 1 && esquerda) || (dir_parede == -1 && direita)) {
            estado = "pulando";
            velh = -dir_parede * 2; 
        }
        
        break;
    }
    #endregion

	#region dash
    case "dash":{
        sprite_index = spr_jogador_dash; 
        image_speed = 1.5; // (Ou a velocidade que você definiu)
        
        // 1. DEFINIÇÃO DE DIREÇÃO E VELOCIDADE
        var dir_dash = sign(image_xscale);
        if (dir_dash == 0) dir_dash = 1;

        if (wall_jump_delay <= 0) {
            if (keyboard_check(ord("D")) || gamepad_axis_value(gamepad_slot, gp_axislh) > 0.2) dir_dash = 1;
            else if (keyboard_check(ord("A")) || gamepad_axis_value(gamepad_slot, gp_axislh) < -0.2) dir_dash = -1;
        }
        
        image_xscale = dir_dash;
        xscale_visual = dir_dash;
        mid_velh = dir_dash * dash_vel;
        
        velh = 0; 
        velv = 0; 

        // =========================================================
        // [NOVO] INTERRUPÇÃO POR PAREDE (CRASH INTO WALL)
        // =========================================================
        // Verifica se tem uma parede logo à frente (na direção do dash)
        var parede_frente = place_meeting(x + dir_dash, y, obj_bloco);

        // Só entra se: 1. Tocou na parede, 2. Está no ar, 3. Tem a habilidade
        if (parede_frente && !chao && global.tem_wall_slide) {
             
             estado = "wall_slide";
             
             // Define de que lado está a parede para o estado wall_slide saber
             if (dir_dash == 1) dir_parede = 1;
             else dir_parede = -1;

             // Zera a velocidade do dash IMEDIATAMENTE (para não escorregar)
             mid_velh = 0;
             velh = 0;
             
             // Reseta a animação para o normal
             image_speed = 1; 
             
             // Opcional: Efeito de impacto ou poeira
             // instance_create_layer(x + dir_dash * 5, y, "Efeitos", obj_poeira_impacto);
             
             break; // Sai do switch agora mesmo!
        }

        // =========================================================
        // 2. DASH CANCEL (PULO)
        // =========================================================
        var vou_pular = buffer_timer > 0;
        var posso_pular_chao = (chao || coyote_timer > 0);
        var posso_pular_ar = (pulos_restantes > 0 && global.tem_pulo_duplo);

        if (vou_pular && (posso_pular_chao || posso_pular_ar)) {
            estado = "pulando";
            velv = -max_velv; 
            velh = mid_velh; 
            mid_velh = 0;
            buffer_timer = 0; 
            image_index = 0;
            if (!posso_pular_chao) pulos_restantes--;
            image_speed = 1; 
            break; 
        }

		// =========================================================
        // 3. FIM DO DASH (CORRIGIDO PARA COMBO)
        // =========================================================
        if (image_index >= image_number - 1){
            
            if (chao) {
                if (direita || esquerda) estado = "movendo";
                else estado = "parado";
            } else {
                estado = "pulando";
            }
            
            velh = mid_velh; 
            mid_velh = 0;
            velv = 0; 
            
            // [AQUI ESTÁ A MUDANÇA]
            // Se veio da parede, NÃO aplica o cooldown (timer = 0).
            // Assim podes dar o segundo dash imediatamente.
            if (veio_da_parede) {
                dash_timer = 0;
                veio_da_parede = false; // Reseta a variável para a próxima
            } else {
                dash_timer = dash_delay; // Dash normal tem cooldown
            }

            wall_jump_delay = 0; 
            image_speed = 1; 
        }
        break;
    }
    #endregion
	
}

