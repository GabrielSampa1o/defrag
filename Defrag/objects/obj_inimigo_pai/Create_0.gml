/// @description Insert description here
// You can write your code in this editor
 /// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

///@method leva_dano(sprite, image_index_ir_para_morto)
leva_dano = function(_sprite, _image_index){
//iniciando o meu delay
	delay = room_speed * 2;
	velh = 0;
		
	mid_velh = 0;
	// Troca Sprite
    if (sprite_index != _sprite){
        sprite_index = _sprite;
        image_index = 0;
    }
		
	//consicao para sair do estado

			
	//checando se ainda tenho vida
	// Saída do Estado
    if(vida_atual > 0){
        // Se a animação acabou, volta para parado
        if(image_index >= image_number - 1){
            estado = "parado"; 
            // Dica: Se quiser que ele volte já perseguindo, mude para "perseguindo"
            // mas cuidado para ele não te bater instantaneamente.
        }
    }else{
        // Se morreu
        if (image_index >= _image_index){
            estado = "morto";
        }
    }
}


//criando o método de ataque
///@method atacando()
///@args sprite_index image_index_min image_index_max dist_x dist_y, [xscale_dano], [yscale_dano], [proximo_estado]
atacando = function(_sprite_index, _image_index_min, _image_index_max, _dist_X, _dist_y, _xscale_dano, _yscale_dano, _proximo_estado){
    
    // ... (seu código de inicialização igual) ...
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
    
    // ... (código de saída do estado) ...
    if(image_index > image_number-1){
        estado = _proximo_estado;
    }

    // CRIANDO DANO (COM PROPRIEDADES)
    if (image_index >= _image_index_min && dano == noone && image_index < _image_index_max && posso){
        
        // Ajusta direção baseado no lado que o inimigo olha
        var _dir = sign(image_xscale); 
        if (_dir == 0) _dir = 1;
        
        dano = instance_create_layer(x + (_dist_X * _dir), y + _dist_y, layer, obj_dano);
        dano.dano = ataque;
        dano.pai = id;
        dano.image_xscale = _xscale_dano;
        dano.image_yscale = _yscale_dano;
        
        // [IMPORTANTE] Definir as forças de impacto do inimigo
        dano.forca_knockback = 10; // Força que empurra o player
        dano.tremor_hit = 4;       // Treme a tela ao acertar
        
        posso = false;
    }
    
    // Destruindo o dano (igual)
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


// --- MÉTODOS DE ESTADO GENÉRICOS ---

/// @method estado_parado(sprite_idle, [tempo_ronda])
/// @desc Comportamento padrão de ficar parado e olhar em volta
estado_parado = function(_sprite, _tempo_ronda = 300) {
    velh = 0;
    timer_estado++;
    
    // Sprite
    if (sprite_index != _sprite) {
        sprite_index = _sprite;
        image_index = 0;
    }
    
    // Ronda Aleatória
    if (random(timer_estado) > _tempo_ronda) {
        estado = choose("parado", "movendo");
        timer_estado = 0;
    }
    
    // IA: Detecção (Aggro)
    scr_checar_aggro(); // Vamos criar esse helper abaixo
}

/// @method estado_movendo(sprite_move, vel_patrulha, [tempo_ronda])
/// @desc Patrulha simples (vai e volta)
estado_movendo = function(_sprite, _vel_patrulha, _tempo_ronda = 200) {
    timer_estado++;
    
    if (sprite_index != _sprite) {
        sprite_index = _sprite;
        image_index = 0;
    }
    
    // Escolhe direção se estiver parado
    if (mid_velh == 0) {
        var _dir = choose(-1, 1);
        mid_velh = _dir * _vel_patrulha;
        image_xscale = _dir;
    }
    velh = mid_velh;
    
    // IA: Detecção
    scr_checar_aggro();
    
    // Voltar a ficar parado
    if (random(timer_estado) > _tempo_ronda) {
        estado = "parado";
        timer_estado = 0;
        mid_velh = 0;
    }
}

/// @method estado_perseguindo(sprite_run, vel_run, dist_ataque, dist_desiste)
/// @desc Corre atrás do player e ataca se chegar perto
estado_perseguindo = function(_sprite, _vel_run, _dist_ataque, _dist_desiste) {
    if (sprite_index != _sprite) {
        sprite_index = _sprite;
        image_index = 0;
    }
    
    if (instance_exists(obj_jogador)) {
        // Olha e move para o player
        var _dir = sign(obj_jogador.x - x);
        if (_dir != 0) {
            image_xscale = _dir;
            velh = _dir * _vel_run;
        }
        
        var _dist = point_distance(x, y, obj_jogador.x, obj_jogador.y);
        
        // Atacar
        if (_dist < _dist_ataque) {
            estado = "atacando";
            velh = 0;
        }
        // Desistir
        if (_dist > _dist_desiste) {
            estado = "parado";
            velh = 0;
        }
    } else {
        estado = "parado";
    }
}

/// @method scr_checar_aggro()
/// @desc Helper interno para checar se o player está perto
scr_checar_aggro = function() {
    if (instance_exists(obj_jogador)) {
        var _dist = point_distance(x, y, obj_jogador.x, obj_jogador.y);
        // Usa a variável dist_aggro definida no Create do inimigo
        if (_dist < dist_aggro) {
            estado = "perseguindo";
        }
    }
}