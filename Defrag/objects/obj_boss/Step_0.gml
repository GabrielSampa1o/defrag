/// @description Insert description here
// You can write your code in this editor


var chao = place_meeting(x, y + 1, obj_bloco);

if (!chao){
	velv += GRAVIDADE * massa * global.vel_mult;
}

//maquina de estado

switch(estado){
	case "parado":{
		//criar a logica do estado parado
		//ajustando a sprite
		if(sprite_index != spr_boss_idle){
			sprite_index = spr_boss_idle;
			image_index = 0;
		}
		
		//condições para troca de estado
		//checando se o player esta na tela
		if(instance_exists(obj_jogador)){
			var _dist = point_distance(x, y, obj_jogador.x, obj_jogador.y);
			//se o player estiver mmuito perto, eu vou atras dele
			if(_dist < 300){
				estado = "movendo";
			}
		}
		
		break;
	}
	case "movendo":{
		
		//criar a logica do estado movendo
		//
		if(sprite_index != spr_boss_andando){
			sprite_index = spr_boss_andando;
			image_index = 0;
		}
		
		//perseguir o player
		if(instance_exists(obj_jogador)){
			//minha distancia para o player
			var _dist = point_distance(x, y, obj_jogador.x, obj_jogador.y);
			var _dir = point_direction(x, y, obj_jogador.x, obj_jogador.y);
			
			if(_dist > 40){
				//defininfo a minha velocidade
				velh = lengthdir_x(max_velh, _dir);
			}else{
				
				//chegou muito perto ele para e ataca
				velh = 0;
				estado = "atacando";
				//escolhendo o ataque
				ataque = irandom(2);
			}
			
		}
		
		break;
	}
	case "atacando":{
		//criando o sub estado do boss
		switch(ataque){
			//primeiro ataque do boss
			case 0:
				atacando(spr_boss_ataque1, 2, 6, sprite_width/2, - sprite_height/3, 2 , 2, "taunt");
				break;
			//segundo ataque do boss
			case 1:
				atacando(spr_boss_ataque2, 2, 4, sprite_width/2.5, - sprite_height/3, 3 , 1, "taunt");
				break;
			//terceito ataque do boss
			case 2:
				atacando(spr_boss_ataque3, 4, 7, 0, - sprite_height/3, 2 , 1, "taunt");
				break;
		}
		
		break;
	}
	case "hit":{
		leva_dano(spr_boss_hit, 2);
		
		break;
	}
	
	
	case "taunt":{
		
		taunt_timer--;
		//definindo a sprite
		if(sprite_index != spr_boss_taunt){
			sprite_index = spr_boss_taunt;
			image_index = 0;
		}
		//condição para sair do estado
		//player atacaou
		if(taunt_timer <= 0){
			taunt_timer= room_speed;
			estado = "parado";
		}
		
		
		break;
	}
	
	case "morto":{
        
        // 1. SETUP (Executa APENAS no primeiro frame que entra em "morto")
        if (sprite_index != spr_boss_dead){
            
            // --- SINALIZAÇÃO E EFEITO DE ENTRADA ---
            
            // Garante que o Game Over/Vitória seja sinalizado SOMENTE AGORA
            if (instance_exists(obj_game_controller)) {
                 obj_game_controller.game_over = true;
                 obj_game_controller.show_thanks_message = true; // Gatilho da mensagem final
            }
            
            // Game Feel: Tremor forte (Executa apenas 1 vez)
            screenshake(7);
            
            // Limpa velocidade e define sprite inicial
            velh = 0;
            velv = 0;
        }
        
        // 2. ANIMAÇÃO DE MORTE (Executa a cada frame)
        // A função morrendo lida com o fade-out, a animação e a destruição final.
        morrendo(spr_boss_dead); 
        
        break;
    }
}


