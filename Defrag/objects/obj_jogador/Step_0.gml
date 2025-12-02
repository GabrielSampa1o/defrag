/// @description Lógica Principal (Input, Estados) - CORRIGIDO

// =========================================================
// 0. CONTROLE DE INVENCIBILIDADE (PISCAR)
// =========================================================
if (invencivel) {
    tempo_invencivel--;
    // Pisca entre 0.4 e 1.0
    image_alpha = 0.7 + 0.3 * sin(get_timer() / 50000); 
    if (tempo_invencivel <= 0) {
        invencivel = false;
        image_alpha = 1;
    }
} else {
    image_alpha = 1; 
}

// =========================================================
// 1. TIMERS E CHECAGENS BÁSICAS
// =========================================================
var chao = place_meeting(x, y + 1, obj_bloco); 

if(dash_timer > 0) dash_timer--;
if(wall_jump_delay > 0) wall_jump_delay--;

// =========================================================
// 2. SISTEMA DE DANO DE CONTATO (PRIORIDADE ALTA)
// =========================================================
// O dano roda ANTES do movimento para ter prioridade.
var inimigo_tocou = instance_place(x, y, obj_inimigo_pai);

if (inimigo_tocou != noone && !invencivel && vida_atual > 0 && estado != "morto" && estado != "hit") {
    
    // Tira vida e muda estado
    vida_atual -= 1;
    estado = "hit";
    image_index = 0;
    
    // Aplica Empurrão (Knockback)
    // Calcula a direção contrária ao inimigo
    var dir_empurrao = sign(x - inimigo_tocou.x);
    if (dir_empurrao == 0) dir_empurrao = 1;
    
    // Força bruta no velh e velv
    // Isso vai funcionar porque o bloco de "inputs" abaixo será ignorado
    velh = dir_empurrao * 6;  // Força horizontal
    velv = -4;                // Pulinho
    mid_velh = 0;             // Zera qualquer inércia anterior
    
    invencivel = true;
    tempo_invencivel = invencivel_timer;
    screenshake(4);
}

// =========================================================
// 3. CAPTURA DE INPUTS E MOVIMENTO (CONDICIONAL)
// =========================================================

// Inicializa variáveis locais zeradas
var direita = 0;
var esquerda = 0;
var pulo = 0;
var dash = 0;
var atk_press = 0;
var pulo_solto = 0;

// [CORREÇÃO CRUCIAL] 
// Só calcula movimento do teclado se NÃO estiver em HIT ou MORTO.
// Isso impede que o teclado "freire" o empurrão do dano.
if (estado != "hit" && estado != "morto") {

    // --- Inputs ---
    direita = keyboard_check(ord("D")) || gamepad_button_check(gamepad_slot, gp_padr) || (gamepad_axis_value(gamepad_slot, gp_axislh) > 0.2);
    esquerda = keyboard_check(ord("A")) || gamepad_button_check(gamepad_slot, gp_padl) || (gamepad_axis_value(gamepad_slot, gp_axislh) < -0.2);
    pulo = keyboard_check_pressed(ord("K")) || gamepad_button_check_pressed(gamepad_slot, gp_face1);
    dash = keyboard_check_pressed(ord("L")) || gamepad_button_check_pressed(gamepad_slot, gp_face2); 
    pulo_solto = keyboard_check_released(ord("K")) || gamepad_button_check_released(gamepad_slot, gp_face1);
    atk_press = keyboard_check_pressed(ord("J")) || gamepad_button_check_pressed(gamepad_slot, gp_face3);
    
    // --- Troca de Arma ---
    var trocar_arma = keyboard_check_pressed(ord("Q")) || gamepad_button_check_pressed(gamepad_slot, gp_face4);
    if (trocar_arma && global.tem_espada) {
        if (arma_atual == "punho") arma_atual = "espada"; else arma_atual = "punho";
    }
	
	// Se estiver atacando ou carregando, fingimos que não estamos apertando para andar.
    // Isso permite que o resto do código (combos, pulo) funcione, mas trava o pé no chão.
    if (estado == "ataque" || estado == "carregando") {
        direita = 0;
        esquerda = 0;
    }

    // --- Lógica de Movimento ---
    if (wall_jump_delay > 0) { direita = 0; esquerda = 0; }

    var move_dir = (direita - esquerda);

    // Aceleração / Fricção
    if (move_dir != 0) {
        velh = lerp(velh, move_dir * max_velh, aceleracao);
    } else {
        velh = lerp(velh, 0, friccao);
    }
    
    if (abs(velh) > 0.5) image_xscale = sign(velh);

    // --- Gravidade e Pulo Variável ---
    if (!chao && estado != "dash" && estado != "wall_slide") {
        if (velv < max_velv * 2) velv += GRAVIDADE * massa;
        if (pulo_solto && velv < 0) velv *= 0.5; 
    }
    
   // --- Gatilho de Ataque ---
    if (atk_press && posso && estado != "ataque" && estado != "dash" && estado != "wall_slide") {
        
        // [CORREÇÃO] VIRAR INSTANTANEAMENTE
        // Se estiver apertando para um lado, vira para esse lado AGORA.
        // Ignora a velocidade atual.
        if (direita) image_xscale = 1;
        else if (esquerda) image_xscale = -1;
        
        // Atualiza também o visual para não dar "glitch" gráfico
        if (variable_instance_exists(id, "xscale_visual")) xscale_visual = image_xscale;
        
        estado = "carregando"; 
        velh = 0; 
        timer_carga = 0; 
        eh_ataque_carregado = false; 
        image_index = 0;
    }
    
    // --- Timers de Pulo ---
    if (chao) {
        pulos_restantes = max_pulos;
        coyote_timer = coyote_max;
        dash_aereo_disponivel = true;
    } else {
        if (coyote_timer <= 0 && pulos_restantes == max_pulos) pulos_restantes = max_pulos - 1;
        if (coyote_timer > 0) coyote_timer--;
    }
    
    if (pulo) buffer_timer = buffer_max;
    if (buffer_timer > 0) buffer_timer--;

} 
// SE ESTIVER EM HIT (FÍSICA DE EMPURRÃO)
else if (estado == "hit") {
    // Aplica fricção suave para o empurrão (que definimos lá em cima) parar aos poucos
    if (chao) velh = lerp(velh, 0, 0.05); // Para devagar no chão
    else {
        velh = lerp(velh, 0, 0.02);       // Para muito devagar no ar
        velv += GRAVIDADE * massa;        // Gravidade continua no hit aéreo
    }
}
// SE ESTIVER MORTO
else if (estado == "morto") {
    velh = 0;
    if (!chao) velv += GRAVIDADE * massa;
}

// Inércia Aérea (Sempre roda para Dash/WallJump)
mid_velh = lerp(mid_velh, 0, 0.08); 




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
        
        // [TRAVAR MOVIMENTO]
        // Se for o primeiro frame do ataque, zera a velocidade.
        if (image_index < 1 && combo == 0) velh = 0;
        else velh = lerp(velh, 0, 0.25); 
        
        // --- COMPORTAMENTO VISUAL (PUNHO/ESPADA) ---
        if (arma_atual == "punho") {
            if (eh_ataque_carregado) {
                sprite_index = spr_jogador_soco_carregado; 
                ataque_mult = 2.5;
            } else {
                if (combo == 0) {
                    sprite_index = spr_jogador_soco1; 
                    image_speed = 2; 
                    ataque_mult = 0.8; 
                } else if (combo == 1) {
                    sprite_index = spr_jogador_soco2;
                    image_speed = 1.5; 
                    ataque_mult = 1.2;
                }
            }
        }
        else if (arma_atual == "espada") {
             if (eh_ataque_carregado) {
                sprite_index = spr_jogador_espada_estocada; 
                ataque_mult = 3.0; 
            } else {
                sprite_index = spr_jogador_espada; 
                ataque_mult = 1.5; 
            }
        }

        // --- CRIAÇÃO DO DANO (AJUSTADA) ---
        if(image_index >= 1 && dano == noone && posso){
            
            // 1. Configura distância
            var _dist_x = 0;
            var _dist_y = -sprite_height/2; // Altura do peito
            
            if (arma_atual == "punho") {
                _dist_x = 15; // Soco é curto
            } 
            else if (arma_atual == "espada") {
                _dist_x = 30; // Espada alcança mais
            }
            
            // 2. Cria hitbox na posição e direção certa
            dano = instance_create_layer(x + (_dist_x * image_xscale), y + _dist_y, layer, obj_dano);
            dano.dano = ataque * ataque_mult;
            dano.pai = id;
            dano.image_xscale = image_xscale; // Vira a hitbox
            
            // 3. Define forças de impacto
            if (eh_ataque_carregado) {
                dano.forca_knockback = 20; 
                dano.tremor_hit = 6;
            } else {
                dano.forca_knockback = 10; 
                dano.tremor_hit = 2;
            }
            posso = false;
        }
        
        // --- FIM DO ATAQUE ---
        if (image_index >= image_number - 0.5){ 
            if (direita || esquerda) estado = "movendo";
            else estado = "parado";
            
            velh = 0;
            posso = true;
            ataque_mult = 1;
            combo = 0; 
            eh_ataque_carregado = false; 
            image_speed = 1; 
            
            finaliza_ataque();
        }
        
        // --- LÓGICA DE COMBO ---
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
            velh = image_xscale * 2; 
        }
        
        // Cancelamentos
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
       // --- CRIAÇÃO DO DANO AÉREO ---
        if(image_index >= 1 && dano == noone && posso){
            
            // Distância do aéreo (pode ser diferente do chão)
            var _dist_x = 20; 
            var _dist_y = -sprite_height/2;
            
            if (arma_atual == "espada") _dist_x = 35; // Espada aérea alcança mais
            
            // Cria na posição corrigida
            dano = instance_create_layer(x + (_dist_x * image_xscale), y + _dist_y, layer, obj_dano);
            
            dano.dano = ataque;
            dano.pai = id;
            dano.forca_knockback = 8;
            dano.tremor_hit = 2;
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
        image_speed = 1.5; 
        
        // =========================================================
        // 1. INVENCIBILIDADE (SHADOW DASH)
        // =========================================================
        // Torna o player imune a tudo enquanto estiver neste estado
        invencivel = true;
        tempo_invencivel = 2; // Mantém o timer > 0 para a lógica do topo do Step não bugar
        
        // Opcional: Visual de "Fantasma" (Transparente fixo, sem piscar)
        image_alpha = 0.5; 

        // =========================================================
        // 2. DEFINIÇÃO DE DIREÇÃO E VELOCIDADE
        // =========================================================
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
        // 3. INTERRUPÇÃO POR PAREDE
        // =========================================================
        var parede_frente = place_meeting(x + dir_dash, y, obj_bloco);

        if (parede_frente && !chao && global.tem_wall_slide) {
             estado = "wall_slide";
             if (dir_dash == 1) dir_parede = 1; else dir_parede = -1;
             mid_velh = 0;
             velh = 0;
             image_speed = 1; 
             
             // [IMPORTANTE] Desliga invencibilidade ao bater na parede
             invencivel = false; 
             image_alpha = 1;
             
             break; 
        }

        // =========================================================
        // 4. DASH CANCEL (PULO)
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
            
            // [IMPORTANTE] Desliga invencibilidade ao cancelar
            invencivel = false;
            image_alpha = 1;
            
            break; 
        }

        // =========================================================
        // 5. FIM DO DASH
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
            
            if (veio_da_parede) {
                dash_timer = 0;
                veio_da_parede = false; 
            } else {
                dash_timer = dash_delay; 
            }

            wall_jump_delay = 0; 
            image_speed = 1; 
            
            // [IMPORTANTE] Desliga invencibilidade ao terminar
            invencivel = false;
            image_alpha = 1;
        }
        break;
    }
    #endregion
	
	#region hit
    case "hit":{
        // Configuração inicial da sprite
        if(sprite_index != spr_jogador_levando_dano){
            sprite_index = spr_jogador_levando_dano;
            image_index = 0;
        }
        
        // [CORREÇÃO] FRICÇÃO EM VEZ DE PARADA BRUSCA
        // Isso permite que o 'velh = 8' que definimos lá em cima funcione,
        // mas vá diminuindo até zero suavemente.
        if (chao) {
            velh = lerp(velh, 0, 0.05); // Desliza no chão
        } else {
            velh = lerp(velh, 0, 0.02); // Desliza mais no ar
            velv += GRAVIDADE * massa;  // Cai se estiver no ar
        }
        
    
            // Saída do estado
        if(vida_atual > 0){
            if(image_index >= image_number - 1) {
                estado = "parado";
                
                // [CORREÇÃO CRUCIAL]
                // Reseta variáveis de combate para não travar o ataque depois
                posso = true; 
                combo = 0;
                eh_ataque_carregado = false;
                timer_carga = 0;
                
                // Destrói qualquer hitbox antiga que ficou órfã
                if (dano) { instance_destroy(dano, false); dano = noone; }
            }
        }
         else {
            if(image_index >= image_number - 1) estado = "morto";
        }
        break;
    }
    #endregion
	
	#region morto
    case "morto":{
        
        // =========================================================
        // 1. CONFIGURAÇÃO INICIAL (Roda 1 vez ao entrar)
        // =========================================================
        if(sprite_index != spr_jogador_morrendo){
            sprite_index = spr_jogador_morrendo;
            image_index = 0;
            
            // Trava o movimento horizontal imediatamente
            velh = 0; 
            
            // Game Feel: Tremor forte para sinalizar a falha
            screenshake(6); 
            
            // Opcional: Efeito visual de "Desligando" (Cor escura ou Glitch)
            image_blend = c_gray; 
            
            // Opcional: Som de desligamento/morte
            // audio_play_sound(snd_game_over, 1, false);
        }
        
        // =========================================================
        // 2. FÍSICA (O corpo ainda obedece à gravidade!)
        // =========================================================
        // Se morrer no ar, ele deve cair até o chão
        if (!chao) {
            velv += GRAVIDADE * massa;
        } else {
            velv = 0;
        }
        
        // =========================================================
        // 3. FINALIZAÇÃO E CONTROLE
        // =========================================================
        
        // Quando a animação de morte terminar...
        if (image_index >= image_number - 1){
            
            // Congela no último frame (cadáver no chão)
            image_index = image_number - 1; 
            
            // Avisa o controlador que a "cutscene" da morte acabou
            // O controlador que lidará com a tela de Game Over e o Respawn na Cooler Station
            if(instance_exists(obj_game_controller)){
                obj_game_controller.game_over = true; 
            } else {
                // Fallback para testes (se não tiver controlador)
                // game_restart(); 
            }
        }
        
        break;
    }
    #endregion
}


