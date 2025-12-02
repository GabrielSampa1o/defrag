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


// 1. INPUTS
var atk_press = keyboard_check_pressed(ord("J")) || gamepad_button_check_pressed(gamepad_slot, gp_face3);

// 2. GATILHO PARA ENTRAR NO ESTADO
// Se apertou o botão e pode atacar, vai para o modo de "preparação/carga"
if (atk_press && posso && estado != "ataque" && estado != "dash" && estado != "wall_slide") {
    estado = "carregando";
    velh = 0; // Para de andar instantaneamente
    timer_carga = 0;
    eh_ataque_carregado = false;
    image_index = 0;
}

// --- TROCA DE ARMA ---
var trocar_arma = keyboard_check_pressed(ord("Q")) || gamepad_button_check_pressed(gamepad_slot, gp_face4); // Botão de cima (Y/Triângulo)

if (trocar_arma) {
    // Só deixa trocar se já tiver desbloqueado a espada
    if (global.tem_espada) {
        
        if (arma_atual == "punho") {
            arma_atual = "espada";
            // Opcional: Som de sacar espada
            // audio_play_sound(snd_espada_draw, 1, false);
            
            // Opcional: Efeito visual ou texto
            show_debug_message("Arma: Espada");
        } 
        else {
            arma_atual = "punho";
            show_debug_message("Arma: Punho");
        }
    }
}

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

// Configuração de sensibilidade (Coloque no Create depois se quiser)
var aceleracao = 0.8; // Quanto menor, mais "pesado"
var friccao = 0.4;    // Quanto menor, mais "escorrega"

// Calcula a direção que o jogador QUER ir
var move_dir = (direita - esquerda);

// Se estiver travado pelo wall jump, ignoramos a entrada
if (wall_jump_delay > 0) move_dir = 0;

// Aceleração e Fricção
if (move_dir != 0) {
    // Acelerar: Aproxima a velocidade atual da velocidade máxima
    velh = lerp(velh, move_dir * max_velh, aceleracao);
} else {
    // Frear: Aproxima a velocidade de zero
    velh = lerp(velh, 0, friccao);
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
	
	#region ataque
    case "ataque":{
        
        // [CORREÇÃO 1] TRAVAR MOVIMENTO INSTANTANEAMENTE
        // Removemos o lerp suave. Agora é 0 absoluto.
        // O personagem "planta" os pés no chão para bater.
        velh = 0; 
        
        // --- COMPORTAMENTO VISUAL (PUNHO/ESPADA) ---
        if (arma_atual == "punho") {
            if (eh_ataque_carregado) {
                sprite_index = spr_jogador_soco_carregado; 
                ataque_mult = 2.5;
            } else {
                // Combo normal
                if (combo == 0) {
                    sprite_index = spr_jogador_soco1; 
                    image_speed = 2; // Rápido
                    ataque_mult = 0.8; 
                } else if (combo == 1) {
                    sprite_index = spr_jogador_soco2;
                    image_speed = 1.5; 
                    ataque_mult = 1.2;
                }
            }
        }
        else if (arma_atual == "espada") {
            // ... (sua lógica de espada mantida) ...
             if (eh_ataque_carregado) {
                sprite_index = spr_jogador_espada_estocada; 
                ataque_mult = 3.0; 
            } else {
                sprite_index = spr_jogador_espada; 
                ataque_mult = 1.5; 
            }
        }

        // --- CRIAÇÃO DO DANO ---
        if(image_index >= 1 && dano == noone && posso){
            dano = instance_create_layer(x + sprite_width/2, y - sprite_height/2, layer, obj_dano);
            dano.dano = ataque * ataque_mult;
            dano.pai = id;
            
            // Empurrão no inimigo
            if (eh_ataque_carregado) {
                dano.forca_knockback = 20;
                screenshake(5);
            } else {
                dano.forca_knockback = 10;
                screenshake(2);
            }
            posso = false;
        }
        
        // --- FIM DO ATAQUE (VOLTA A MOVER) ---
        if (image_index >= image_number - 0.5){ // Sai um pouco antes do fim da anim
            
            // [CORREÇÃO 2] FLUIDEZ DE MOVIMENTO
            // Se o jogador estiver segurando para andar, já sai correndo.
            if (direita || esquerda) {
                estado = "movendo";
            } else {
                estado = "parado";
            }
            
            velh = 0;
            posso = true;
            ataque_mult = 1;
            combo = 0; // Reseta combo
            eh_ataque_carregado = false; 
            image_speed = 1; 
            
            finaliza_ataque();
        }
        
        // --- LÓGICA DE COMBO (MANTIDA) ---
        if (!eh_ataque_carregado && combo < 1) {
            if (keyboard_check_pressed(ord("J")) || gamepad_button_check_pressed(gamepad_slot, gp_face3)) {
                ataque_buff = room_speed;
            }
        }
        
        if(ataque_buff > 0 && combo < 1 && image_index >= image_number-1 && !eh_ataque_carregado){
            combo++;
            image_index = 0;
            posso = true;
            if(dano) { instance_destroy(dano, false); dano = noone; }
            ataque_buff = 0;
            
            // Pequeno avanço APENAS na troca de soco (opcional)
            velh = image_xscale * 2; 
        }
        
        // Cancelamentos (Dash/Queda)
        if(dash && dash_timer <= 0 && global.tem_dash){
            estado = "dash"; image_index = 0; combo = 0; eh_ataque_carregado = false; image_speed = 1;
            if(dano) { instance_destroy(dano, false); dano = noone; }
        }
        if( velv != 0){
            estado = "pulando"; image_index = 0; combo = 0; eh_ataque_carregado = false;
            finaliza_ataque();
        }
        break;
    }
    #endregion
	
#region ataque aereo
    case "ataque aereo":{
        
        // 1. VISUAL
        if (arma_atual == "punho") sprite_index = spr_jogador_soco1; // Crie este sprite
        else sprite_index = spr_jogador_espada; // E este
        
        // 2. FÍSICA (Gravidade + Movimento Lento)
        if (!chao) {
            velv += GRAVIDADE * massa;
            
            // Permite mover um pouco no ar enquanto bate
            var move_dir = (direita - esquerda);
            if (move_dir != 0) velh = lerp(velh, move_dir * max_velh * 0.8, 0.1);
            else velh = lerp(velh, 0, 0.05);
        }
        
        // 3. DANO
        if(image_index >= 1 && dano == noone && posso){
            dano = instance_create_layer(x + sprite_width/2, y - sprite_height/2, layer, obj_dano);
            dano.dano = ataque;
            dano.pai = id;
            dano.forca_knockback = 8;
            posso = false;
        }
        
        // 4. FIM (SEM COMBO)
        if (image_index >= image_number - 1){
            if (chao) {
                // Se cair no chão terminando o ataque, já sai movendo se quiser
                if (direita || esquerda) estado = "movendo";
                else estado = "parado";
            } else {
                estado = "pulando";
            }
            
            // Reseta tudo para garantir
            combo = 0; 
            posso = true;
            finaliza_ataque();
        }
        
        // 5. LANDING CANCEL (Tocar o chão cancela o ataque aéreo)
        if (chao) {
            if (direita || esquerda) estado = "movendo";
            else estado = "parado";
            
            if (dano) { instance_destroy(dano, false); dano = noone; }
            finaliza_ataque();
        }
        
        break;
    }
    #endregion

	#region carregando
    case "carregando":{
        velh = 0; 
        
        // 1. AUMENTA O TIMER
        timer_carga++;
        
        // =========================================================
        // [NOVO] LIMITE DE TEMPO (OVERHEAT)
        // =========================================================
        if (timer_carga >= tempo_limite_carga) {
            // Se segurou demais: CANCELA O ATAQUE
            estado = "parado";
            timer_carga = 0;
            eh_ataque_carregado = false;
            image_blend = c_gray; // Fica cinza (queimado/cansado) por um instante
            
            // Opcional: Som de falha
            // audio_play_sound(snd_falha_carga, 1, false);
            
            break; // Sai do estado imediatamente
        }
        
        // AVISO VISUAL QUE VAI FALHAR (Nos últimos 30 frames)
        if (timer_carga > tempo_limite_carga - 30) {
            // Pisca muito rápido ou treme o sprite
            image_alpha = (timer_carga % 2 == 0) ? 1 : 0.5;
        } else {
            image_alpha = 1;
        }
        // =========================================================

        // 2. DEFINE O SPRITE DE PREPARAÇÃO
        if (arma_atual == "punho") {
            sprite_index = sprite_preparacao_soco; 
        } else {
            sprite_index = sprite_preparacao_espada;
        }
        
        // TRAVA NO FRAME
        if (image_index >= image_number - 1) {
            image_index = image_number - 1;
        }
        
        // 3. FEEDBACK DE CARGA PRONTA (BRILHO)
        if (timer_carga >= tempo_para_carregar) {
            // Oscilação suave para mostrar poder
            var oscilacao = sin(get_timer() / 100000);
            image_blend = merge_color(c_white, c_red, abs(oscilacao));
        } else {
            image_blend = c_white;
        }
        
        // 4. VERIFICA SE SOLTOU O BOTÃO
        var atk_check = keyboard_check(ord("J")) || gamepad_button_check(gamepad_slot, gp_face3);
        
        if (!atk_check) {
            
            if (timer_carga >= tempo_para_carregar) {
                eh_ataque_carregado = true;
            } else {
                eh_ataque_carregado = false; 
            }
            
            // DECISÃO SIMPLES: CHÃO OU AR
            if (chao) {
                estado = "ataque";
            } else {
                estado = "ataque aereo"; // Apenas um estado aéreo agora
            }
            image_index = 0; // Vai começar do zero, mas o estado 'ataque' vai corrigir isso
            
            // Reseta visuais
            image_blend = c_white; 
            image_alpha = 1;
            timer_carga = 0;
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

