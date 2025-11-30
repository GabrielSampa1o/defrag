/// @description Insert description here
// You can write your code in this editor

randomize();

// Inherit the parent event
event_inherited();


vida_max = 10;
vida_atual = vida_max;

max_velh = 4;
max_velv = 6;
dash_vel = 6;

mostra_estado = true;

// --- PULO DUPLO ---
max_pulos = 2;       // Total de pulos permitidos
pulos_restantes = 0; // Quantos eu tenho agora

combo = 0;
dano = noone;
posso = true;
ataque_mult =1;
ataque_buff = room_speed;
ataque_baixo = false;
invencivel = false;
invencivel_timer = room_speed * 3; 
tempo_invencivel = invencivel_timer;

dash_delay = 0; //room_speed * 2;
dash_timer = 0;
dash_aereo_timer = 0;
dash_aereo = true;

velh = 0
velv = 0

// --- MELHORIAS DE PULO (Game Feel) ---

// Coyote Time: Tempo que ainda pode pular depois de sair do chão
coyote_max = 6; // Duração em frames (6 frames = 0.1s a 60fps)
coyote_timer = 0;

// Jump Buffering: Tempo que o jogo "lembra" que apertou pular antes de tocar o chão
buffer_max = 6; // Duração em frames
buffer_timer = 0;
