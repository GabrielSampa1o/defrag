/// @description Inicialização e Variáveis do Player
//  Este evento roda apenas uma vez quando o objeto nasce.

randomize(); // Garante que sementes aleatórias sejam diferentes

// Herda comportamentos do pai (se tiver)
event_inherited();

// =========================================================
// 1. VIDA E STATUS BÁSICOS
// =========================================================
vida_max = 10;
vida_atual = vida_max;
mostra_estado = true; // Útil para Debug (desenhar o estado na tela)

// =========================================================
// 2. FÍSICA E MOVIMENTO
// =========================================================
max_velh = 5.5;       // Velocidade máxima horizontal andando
max_velv = 8.5;       // Limite de velocidade de queda
velh = 0;             // Velocidade Horizontal Atual
velv = 0;             // Velocidade Vertical Atual
massa = 1;            // Multiplicador da gravidade
mid_velh = 0;         // Velocidade extra (Dash e inércia)

// [NOVO] Ajustes Finos de Movimento (Aceleração/Fricção)
aceleracao = 0.8; // Quanto menor (0.1), mais "pesado" para acelerar
friccao = 0.4;    // Quanto menor (0.1), mais "escorrega" ao parar

// Controle Visual (Para não bugar a colisão)
xscale_visual = 1;

// =========================================================
// 3. WALL JUMP
// =========================================================
wall_slide_spd = 2;      // Velocidade máxima escorregando
wall_jump_hsp = 5;       // Força horizontal do pulo (kickback)
wall_jump_vsp = 6;       // Força vertical do pulo (altura)
dir_parede = 0;          // Direção da parede (1 ou -1)
wall_jump_delay = 0;     // Contador de trava de input
wall_jump_delay_max = 10; // Tempo de trava

// =========================================================
// 4. SISTEMA DE PULO (GAME FEEL)
// =========================================================
max_pulos = 2;       // Total de pulos permitidos
pulos_restantes = 0; 
coyote_max = 6;      // Tolerância em frames
coyote_timer = 0;
buffer_max = 6;      // Memória em frames
buffer_timer = 0;

// =========================================================
// 5. DASH
// =========================================================
dash_vel = 10;          // Velocidade do dash
dash_delay = room_speed; // Tempo de espera
dash_timer = 0;         
dash_aereo = true;      
dash_aereo_timer = 0;
veio_da_parede = false; // Controle de combo Wall->Dash
tem_dash_aereo = true; 
dash_aereo_disponivel = true; 

// =========================================================
// 6. COMBATE
// =========================================================
combo = 0;
combo_max = 1; // Máximo de hits para o punho (0 e 1)
dano = noone;  // Guarda o ID da hitbox de dano
posso = true;  // Controle de intervalo de ataque
ataque_mult = 1; 
ataque_buff = room_speed;
ataque_baixo = false;

// Invencibilidade
invencivel = false;
invencivel_timer = room_speed * 0.8; 
tempo_invencivel = invencivel_timer;

// Sistema de Armas
arma_atual = "punho"; 
global.tem_espada = false;

// Sistema de Carga (Ataque Forte)
timer_carga = 0;
tempo_para_carregar = 20; // 0.3s para brilhar
tempo_limite_carga = room_speed * 3; // 3s para explodir (Overheat)
eh_ataque_carregado = false;

// Sprites de Preparação
sprite_preparacao_soco = spr_jogador_carregando_soco; 
frame_travado_soco = 4;

sprite_preparacao_espada = spr_jogador_carregando_estocada; 
frame_travado_espada = 4; 

// =========================================================
// 7. CONTROLES E HABILIDADES
// =========================================================
gamepad_slot = 0;   
gamepad_set_axis_deadzone(gamepad_slot, 0.25); 

// Habilidades Globais
global.tem_dash = false;        
global.tem_pulo_duplo = false;  
global.tem_wall_slide = false;
global.tem_espada = false;
// =========================================================
// 8. MÉTODOS (FUNÇÕES INTERNAS)
// =========================================================

// Inicia Ataque
inicia_ataque = function(chao){
    if(chao){
        estado = "ataque";
        velh = 0;
        image_index = 0;
    } else {
        // No ar, agora só temos o ataque aéreo padrão (removemos o Pogo)
        estado = "ataque aereo";
        image_index = 0;
    }
}

// Finaliza Ataque
finaliza_ataque = function(){
    posso = true;
    if(dano){
        instance_destroy(dano, false);
        dano = noone;
    }
}

// Método para tomar dano do Boss
leva_dano_player = function(_qtd) {
    if (!invencivel && vida_atual > 0) {
        vida_atual -= _qtd;
        invencivel = true;
        tempo_invencivel = 60; // 1 segundo de i-frames
        estado = "hit";
        image_index = 0;
        screenshake(5);
        
        // Se morrer
        if (vida_atual <= 0) estado = "morto";
    }
}