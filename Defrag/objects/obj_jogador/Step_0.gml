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

// Coyote Time
if (chao) {
    pulos_restantes = max_pulos;
    coyote_timer = coyote_max;
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
        
        // PULO DUPLO (Verifica Habilidade)
        if (buffer_timer > 0 && pulos_restantes > 0 && global.tem_pulo_duplo) {
            velv = -max_velv; 
            pulos_restantes--; 
            image_index = 0;   
            buffer_timer = 0;  
        }
        
        // Sprite Caindo/Pulando
        if(velv > 0){
            sprite_index = spr_jogador_caindo;
            if(image_index >= image_number -1) image_index = image_number -1;
        }else{
            sprite_index = spr_jogador_pulando;
            if(image_index >= image_number -1) image_index = image_number -1;
        }
        
        // Tocou no chão
        if(chao){
            estado = "parado";
            velv = 0;
        }
        
        // Dash Aéreo (Verifica Habilidade)
        if (dash && dash_timer <= 0 && global.tem_dash) {
             estado = "dash";
             image_index = 0;
        }
        break;
    }
    #endregion
    
    #region dash
    case "dash":{
        sprite_index = spr_jogador_dash; 
        
        mid_velh = image_xscale * dash_vel; 
        velh = 0; 
        velv = 0; 

        // DASH CANCEL (Pular no meio do dash)
        if (buffer_timer > 0 && (chao || coyote_timer > 0)) {
            estado = "pulando";
            velv = -max_velv; 
            velh = mid_velh; // Transfere inércia
            mid_velh = 0;
            buffer_timer = 0; 
            image_index = 0;
            break; 
        }

        // Fim do Dash
        if (image_index >= image_number - 1 || !chao){
            estado = "parado";
            
            // Transfere inércia ao acabar (movimento fluido)
            velh = mid_velh; 
            mid_velh = 0;
            
            velv = 0; 
            dash_timer = dash_delay;
        }
        break;
    }
    #endregion
}