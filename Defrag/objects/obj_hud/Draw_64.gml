
//Hud barras

	//configuração da posição
	var posicaoHud_X =87;
	var posicaoHud_Y = 25;

	// --- vida ---
	var w = sprite_get_width(spr_barra_vida);
	var h = sprite_get_height(spr_barra_vida);
	var corte = w * vida_porcentagem;

	// --- energia ---
	var w2 = sprite_get_width(spr_barra_energia);
	var h2 = sprite_get_height(spr_barra_energia);
	var corte2 = w2 * energia_porcentagem;

	// --- desenhar ---
	draw_sprite(spr_barra_layout, 0, posicaoHud_X, posicaoHud_Y);
	draw_sprite_part(spr_barra_energia, 0, 0, 0, corte2, h2, posicaoHud_X, posicaoHud_Y+18);
	draw_sprite_part(spr_barra_vida, 0, 0, 0, corte, h, posicaoHud_X, posicaoHud_Y+2);

