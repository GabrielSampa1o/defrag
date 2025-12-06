/// @description Insert description here
// You can write your code in this editor



// Inherit the parent event
event_inherited();

/// @description Desenha Inimigo + Debug

// 1. Desenha o sprite do inimigo (OBRIGATÓRIO senão ele fica invisível)
draw_self();

// 2. Desenha as informações de Debug
// Se quiser ativar/desativar, pode criar uma global.debug = true;

draw_set_font(-1);
draw_set_halign(fa_center); // Centraliza texto no inimigo
draw_set_valign(fa_bottom); // Texto cresce para cima
draw_set_color(c_white);

// Calcula posição acima da cabeça
var _top_y = y - sprite_height; 

// --- ESTADO ---
// Se estiver perseguindo ou atacando, fica vermelho
if (estado == "perseguindo" || estado == "atacando") draw_set_color(c_orange);
else if (estado == "hit") draw_set_color(c_red);
else draw_set_color(c_white);

draw_text(x, _top_y - 5, string(estado));

// --- VIDA ---
draw_set_color(c_white);
var _hp_texto = string(vida_atual) + "/" + string(vida_max);
draw_text(x, _top_y - 20, "HP: " + _hp_texto);

// Barra de vida flutuante
var _w = 20; // Largura da barra
var _h = 4;  // Altura
var _x1 = x - _w/2;
var _x2 = x + _w/2;
var _y1 = _top_y - 35;
var _y2 = _y1 + _h;
var _pct = (vida_atual / vida_max);

// Fundo (Vermelho)
draw_set_color(c_red);
draw_rectangle(_x1, _y1, _x2, _y2, false);
// Vida Atual (Verde)
draw_set_color(c_lime);
draw_rectangle(_x1, _y1, _x1 + (_w * _pct), _y2, false);

// Reseta alinhamento para não bagunçar outros objetos
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);