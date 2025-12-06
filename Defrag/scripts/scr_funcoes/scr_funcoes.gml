// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_funcoes(){

}


global.dificuldade = 1;

//enumerator para definir as minhas ações possivel
enum menu_acoes{
	roda_metodo,
	carrega_menu,
	ajustes_menu
}

enum menus_lista{
	principal,
	opcoes,
	tela,
	dificuldade
}


//screenshake
///@funcition screenshake(valor_da_tremida)
///@arg forca_da_tremida
///@arg [dir_mode]
///@arg [direcao]
function screenshake(_treme, _dir_mode, _direcao){

	var shake = instance_create_layer(0, 0, "instances", obj_screenshake );
	shake.shake = _treme;
	shake.dir_mode = _dir_mode;
	shake.dir = _direcao;
}

//define align
///@function define_align(vertical, horizontal)
function define_align(_ver, _hor){
	draw_set_halign(_hor);
	draw_set_valign(_ver);
}

//pegar o valor da animation curve
///@function valor_ac(animation_curve, animar, [canal])
function valor_ac(_anim, _animar = false, _chan = 0){
	
	//posicao animao
	static _pos = 0, _val = 0;
	
	//aumentando o valor do pos
	//em 1 segundo o pos vai de 0 até o 1 (final da animação)
	_pos += delta_time / 1000000;
	
	if(_animar) _pos = 0;
	
	//pegando o valor do canal
	var _canal = animcurve_get_channel(_anim, _chan);
	_val = animcurve_channel_evaluate(_canal, _pos);
	
	return _val;
}