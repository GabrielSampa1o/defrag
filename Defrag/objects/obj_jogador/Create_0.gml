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
max_velh = 4;       // Velocidade máxima horizontal andando
max_velv = 6;       // Limite de velocidade de queda (terminal velocity)
velh = 0;           // Velocidade Horizontal Atual
velv = 0;           // Velocidade Vertical Atual

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
global.tem_ataque_aereo = true;