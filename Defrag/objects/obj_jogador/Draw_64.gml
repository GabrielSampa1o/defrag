/// @description HUD de Debug Organizado

// --- CONFIGURAÇÃO ---
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _x = 20;        // Posição X inicial
var _y = 20;        // Posição Y inicial
var _h = 18;        // Altura da linha (Espaçamento)
var _i = 0;         // Contador de linhas (O segredo da organização)

// Função auxiliar para pular linha (opcional, mas ajuda na leitura)
// Basta somar _i sempre que desenhar algo.

// =========================================================
// 1. ESTADO E VIDA
// =========================================================
draw_set_color(c_white);
draw_text(_x, _y + (_h * _i), "--- PLAYER DEBUG ---"); _i++; 

// Estado (Colorido)
if (estado == "hit") draw_set_color(c_red);
else if (invencivel) draw_set_color(c_yellow);
else draw_set_color(c_lime);

draw_text(_x, _y + (_h * _i), "ESTADO: " + string(estado)); _i++;
draw_set_color(c_white);

// Barra de Vida
var hp_pct = (vida_atual / vida_max) * 100;
var _bar_x = _x + 130; // Empurra a barra para a direita do texto
var _bar_y = _y + (_h * _i) + 4; // Ajuste fino vertical

draw_text(_x, _y + (_h * _i), "HP: " + string(vida_atual) + "/" + string(vida_max));

// Desenha a barra na mesma linha do texto
draw_set_color(c_red);
draw_rectangle(_bar_x, _bar_y, _bar_x + 100, _bar_y + 10, false); // Fundo
draw_set_color(c_green);
draw_rectangle(_bar_x, _bar_y, _bar_x + hp_pct, _bar_y + 10, false); // Vida
draw_set_color(c_white);
_i++; // Pula linha

_i += 0.5; // Espacinho extra para separar seções

// =========================================================
// 2. MOVIMENTO
// =========================================================
draw_set_color(c_aqua); // Cor diferente para títulos de seção (opcional)
draw_text(_x, _y + (_h * _i), "[MOVIMENTO]"); _i++;
draw_set_color(c_white);

draw_text(_x, _y + (_h * _i), "Vel H: " + string(velh)); _i++;
draw_text(_x, _y + (_h * _i), "Vel V: " + string(velv)); _i++;
draw_text(_x, _y + (_h * _i), "Inércia: " + string(mid_velh)); _i++;

_i += 0.5;

// =========================================================
// 3. COMBATE
// =========================================================
draw_set_color(c_orange);
draw_text(_x, _y + (_h * _i), "[COMBATE]"); _i++;
draw_set_color(c_white);

draw_text(_x, _y + (_h * _i), "Arma: " + string(arma_atual)); _i++;
draw_text(_x, _y + (_h * _i), "Combo: " + string(combo)); _i++;

// Timer de Carga
var _texto_carga = "Carga: " + string(timer_carga) + "/" + string(tempo_limite_carga);
if (eh_ataque_carregado) {
    _texto_carga += " [PRONTO!]";
    draw_set_color(c_red);
}
draw_text(_x, _y + (_h * _i), _texto_carga); 
draw_set_color(c_white);
_i++;

// Debug de Lógica de Ataque (O que estava solto lá embaixo)
draw_text(_x, _y + (_h * _i), "Posso Atacar?: " + string(posso)); _i++;
draw_text(_x, _y + (_h * _i), "Hitbox Ativa?: " + string(dano)); _i++;

_i += 0.5;

// =========================================================
// 4. HABILIDADES
// =========================================================
draw_set_color(c_yellow);
draw_text(_x, _y + (_h * _i), "[HABILIDADES]"); _i++;
draw_set_color(c_white);

draw_text(_x, _y + (_h * _i), "Pulos: " + string(pulos_restantes) + "/" + string(max_pulos)); _i++;
draw_text(_x, _y + (_h * _i), "Dash Timer: " + string(dash_timer)); _i++;
draw_text(_x, _y + (_h * _i), "Wall Delay: " + string(wall_jump_delay)); _i++;