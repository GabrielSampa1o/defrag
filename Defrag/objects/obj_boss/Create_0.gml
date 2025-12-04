/// @description Insert description here
// You can write your code in this editor


// Inherit the parent event
event_inherited();

//adicionando atributos do boss
vida_max = 50 * global.dificuldade;
vida_atual = vida_max;

max_velh = 3;
max_velv = 3;

timer_estado = 0;

ataque = 5;
massa = 3;

taunt_delay =  room_speed * 2;
taunt_timer = taunt_delay;

//substate
ataque = irandom(2);

///@method leva_dano(sprite, image_index_ir_para_morto)
leva_dano = function(_sprite, _image_index){
//iniciando o meu delay
	delay = room_speed * 2;
	//velh = 0;
		
	//mid_velh = 0;
	//checando se estou com a sprite certa
	if (sprite_index != _sprite){
		//iniciando o que for preciso para esse estado;
		image_index = 0;
		//vida_atual --;
			
			
	}
	sprite_index = _sprite;
		
	//consicao para sair do estado

			
	//checando se ainda tenho vida
	if(vida_atual > 0){
		if(image_index > image_number-1){
			estado = "parado";
		}
	}else{
		if (image_index >= _image_index){
			estado = "morto";
		}
	}
}

//criando o método de ataque
///@method atacando()
///@args sprite_index image_index_min image_index_max dist_x dist_y, [xscale_dano], [yscale_dano], [proximo_estado]
atacando = function(_sprite_index, _image_index_min, _image_index_max, _dist_X, _dist_y, _xscale_dano, _yscale_dano, _proximo_estado){
	
	//caso a pessoa não passe o xcale eu defino ele como 1
	if(!_xscale_dano) _xscale_dano = 1;
	if(!_yscale_dano) _yscale_dano = 1;
	if(_proximo_estado == undefined) _proximo_estado = "parado";
	
	mid_velh = 0;
	velh = 0;
	if(sprite_index != _sprite_index){
		sprite_index = _sprite_index;
		image_index = 0;
		posso = true;
		dano = noone;
	}
		
		
	if(image_index > image_number-1){
		estado = _proximo_estado;
	}
	//saindo do estado
		
	//criando dano
	if (image_index >= _image_index_min && dano == noone && image_index < _image_index_max && posso){
		dano = instance_create_layer(x + _dist_X ,y + _dist_y,layer,obj_dano);
		dano.dano = ataque;
		dano.pai = id;
		dano.image_xscale = _xscale_dano;
		dano.image_yscale = _yscale_dano;
		posso = false;
	}
	//destruindo o dano
	if(dano != noone && image_index >= _image_index_max){
		instance_destroy(dano);
		dano = noone;
	}

}

///@method morrendo(sprite_index)
morrendo = function(_sprite_index){
	mid_velh = 0;
	if (sprite_index != _sprite_index){
		//iniciando o que for preciso para esse estado;
		image_index = 0;
	}
		
	sprite_index = _sprite_index;
	//morrendo de verdade
	if(image_index > image_number -1){
		image_speed = 0;
		image_alpha -= .01;
			
		if (image_alpha <= 0) instance_destroy();
	}

}