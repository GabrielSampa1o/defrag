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
max_velv = 8.5;       // Limite de velocidade de queda (terminal velocity)
velh = 0;           // Velocidade Horizontal Atual
velv = 0;           // Velocidade Vertical Atual


// Configuração do Wall Jump
wall_slide_spd = 2;      // Velocidade máxima escorregando
wall_jump_hsp = 5;       // Força horizontal do pulo (kickback)
wall_jump_vsp = 6;       // Força vertical do pulo (altura)
dir_parede = 0;          // Direção da parede (1 ou -1)

// Controle Visual (Para não bugar a colisão)
xscale_visual = 1;

wall_jump_delay = 0;      // Contador
wall_jump_delay_max = 10; // Tempo que fica sem controle (em frames)

// [IMPORTANTE] Variáveis que faltavam:
massa = 1;          // Multiplicador da gravidade (usado no Step)
mid_velh = 0;       // Velocidade extra (usada para Dash e inércia)

// =========================================================
// 3. SISTEMA DE PULO (GAME FEEL)
// =========================================================
// Pulo Duplo
max_pulos = 2;       // Total de pulos permitidos
pulos_restantes = 0; // Quantos pulos ainda tenho neste momento

// Coyote Time: Permite pular instantes após sair do chão
coyote_max = 6;      // Tolerância em frames (aprox. 0.1s)
coyote_timer = 0;

// Jump Buffer: Memoriza o botão de pulo se apertado antes de tocar o chão
buffer_max = 6;      // Memória em frames
buffer_timer = 0;

// =========================================================
// 4. DASH
// =========================================================
dash_vel = 10;          // Velocidade do dash (geralmente maior que max_velh)
dash_delay = room_speed; // Tempo de espera para usar de novo (coloquei 1 seg)
dash_timer = 0;         // Contador regressivo do delay
dash_aereo = true;      // Se permite dash no ar (opcional)
dash_aereo_timer = 0;

veio_da_parede = false;

// CONTROLE DO DASH AÉREO
tem_dash_aereo = true; // Habilidade desbloqueada? (Se usar global, troque aqui)
dash_aereo_disponivel = true; // Se posso usar AGORA (recarrega no chão)

// =========================================================
// 5. COMBATE
// =========================================================
combo = 0;
dano = noone;           // Guarda o ID da hitbox de dano
posso = true;           // Controle de intervalo de ataque
ataque_mult = 1;        // Multiplicador de força
ataque_buff = room_speed;
ataque_baixo = false;   // Controle do ataque aéreo para baixo

// Invencibilidade após levar dano
invencivel = false;
invencivel_timer = room_speed * 3; 
tempo_invencivel = invencivel_timer;

// =========================================================
// 6. CONTROLES (GAMEPAD)
// =========================================================
gamepad_slot = 0;   // Slot do controle (0 = Player 1)
// Define uma "zona morta" de 25% para evitar que o boneco ande sozinho com drift
gamepad_set_axis_deadzone(gamepad_slot, 0.25); 

// =========================================================
// 7. SISTEMA DE HABILIDADES (DESBLOQUEIOS)
// =========================================================
// Defina como 'true' para testar, ou 'false' para desbloquear via itens
global.tem_dash = true;        
global.tem_pulo_duplo = true;  
global.tem_wall_slide = true;
global.tem_espada = false;

// --- SISTEMA DE ARMAS ---
// Pode ser "punho" ou "espada"
arma_atual = "punho"; 

// --- SISTEMA DE COMBATE REFINADO ---
arma_atual = "punho"; 

// Combo (0 = Jab, 1 = Direto)
combo = 0;
combo_max = 1; // Máximo de hits para o punho (0 e 1)

// Carga
timer_carga = 0;
tempo_para_carregar = 20; // Frames para considerar carregado (aprox 0.3s)
eh_ataque_carregado = false;

// Sprite de preparação (Visual do "segurar botão")
// DICA: Crie sprites onde o personagem puxa o braço para trás
sprite_preparacao_soco = spr_jogador_carregando_soco; // Crie este sprite!
frame_travado_soco = 4 // Qual frame ele congela enquanto carrega?

sprite_preparacao_espada = spr_jogador_carregando_estocada; // Crie este sprite!
frame_travado_espada = 4; // Qual frame ele congela?

// --- SISTEMA DE CARGA ---
timer_carga = 0;
tempo_para_carregar = 20; // 0.3 segundos para ficar pronto

// [NOVO] Limite máximo (Overheat)
// 3 segundos (60 * 3) para segurar a carga. Se passar disso, cancela.
tempo_limite_carga = room_speed * 3;

//////////////////
inicia_ataque = function(chao){
	
	if(chao){
		estado = "ataque";
		velh = 0;
		image_index = 0;
	}else{//nao estou no chao
		if(keyboard_check(ord("S"))){
			estado = "ataque aereo baixo"
			velh = 0;
			image_index = 0;
		}else{
			estado = "ataque aereo";
			image_index = 0;
		}
		
	}
	
}

finaliza_ataque = function(){
	posso = true;
	if(dano){
		instance_destroy(dano, false)
		dano = noone;
	}
}
