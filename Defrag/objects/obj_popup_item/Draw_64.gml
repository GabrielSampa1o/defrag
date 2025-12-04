/// @description Insert description here
// You can write your code in this editor

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Fundo escuro semitransparente (para focar atenção)
draw_set_alpha(0.7 * alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1);

// Caixa do Item
var _cx = _gui_w / 2;
var _cy = _gui_h / 2;

// Desenha caixa (ajuste cores ao seu gosto)
draw_set_color(c_dkgray);
draw_rectangle(_cx - 150 * scale, _cy - 100 * scale, _cx + 150 * scale, _cy + 100 * scale, false);
draw_set_color(c_white);
draw_rectangle(_cx - 150 * scale, _cy - 100 * scale, _cx + 150 * scale, _cy + 100 * scale, true); // Borda

if (scale > 0.8) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Desenha Sprite do Item (Grande)
    if (sprite_item != -1) {
        draw_sprite_ext(sprite_item, 0, _cx, _cy - 40, 2, 2, 0, c_white, alpha);
    }

    // Texto
    draw_set_font(-1); // Use sua fonte
    draw_set_color(c_yellow);
    draw_text(_cx, _cy + 20, titulo);

    draw_set_color(c_white);
    draw_text_ext(_cx, _cy + 60, descricao, 20, 280);

    // Instrução para fechar
    draw_set_font(-1); // Fonte menor se tiver
    draw_text(_cx, _cy + 90, "- Pressione PULO para continuar -");
}





