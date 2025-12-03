// --- Anular fisica do movimento ---
// fixa no chão ou parede, não pode cair (ignora a gravidade)

velh = 0;
velv = 0;

// --- Máquina de estados ---

switch(estado)
{
	
	case "vigilante":
	{
		if(sprite_index != spr_inimigo_torreta_firewall_vigilante)
		{
			image_index = 0;
			sprite_index = spr_inimigo_torreta_firewall_vigilante;
		}
		//se detect player, muda pra atacando
		if(instance_exists(obj_jogador))
		{
			var dist = point_distance(x,y, obj_jogador.x, obj_jogador.y);
			if(dist < raio_alerta)
			{
				estado = "attack";
			}
		}
		//girar devagar de volta pra posição neutra ou ficar parada
		image_angle = lerp(image_angle,0,0.1);
		break;
	}
	
	case "attack":
	{
		if(sprite_index != spr_inimigo_torreta_firewall_attack)
		{
			image_index = 0;
			sprite_index = spr_inimigo_torreta_firewall_attack;
		}
		if(instance_exists(obj_jogador))
		{
			 //1. verificar se o player saiu do raio
			 var dist = point_distance(x, y, obj_jogador.x, obj_jogador.y);
			 if(dist > raio_alerta + 50)
			 {
				 estado = "vigilante";
				 break;
			 }
			 
			 //2. mirar no player
			 var dir_player = point_direction(x, y, obj_jogador.x, obj_jogador.y);
			 image_angle = dir_player - 7; //gira o sprite da torreta
			 var spawn_x = x + lengthdir_x(25, dir_player);
			 var spawn_y = y + lengthdir_y(10, dir_player);
			 var alvo_x = obj_jogador.x;
			 var alvo_y = obj_jogador.y - (obj_jogador.sprite_height/3);
			 //3. atirar
			 if(timer_tiro <= 0 && obj_jogador.estado != "morto")
			 {
				 //verifica se na frente do player tem alguma parede antes de atirar
				 if(!collision_line(x, y, alvo_x, alvo_y, obj_bloco,false, true))
				 {
					var tiro = instance_create_layer(spawn_x,spawn_y, layer, obj_dano_tiro);
					show_debug_message("atirei");
					tiro.dano = ataque;
					tiro.direction = dir_player - 7;
					tiro.image_angle = dir_player - 7;
					tiro.pai = id;
					timer_tiro = delay_tiro; // reseta o timer
				 }
			 }
			 else
			 {
				timer_tiro--; 
			 }
		}
		
		else
		{
			estado = "vigilante";
		}
		
		break;
	}
	
	case "hit":
	{
		
			if(ativacao)
			{
				if(sprite_index != spr_inimigo_torreta_firewall_hit)
				{
					image_index = 0;
					sprite_index = spr_inimigo_torreta_firewall_hit;
				}
				if(timer_tiro > 0) timer_tiro--;
		
				if(image_index > image_number - 1)
				{
					estado = "attack"
				}
		
				if(vida_atual <= 0)
				{
					estado = "explosao";
				}
			}
			else if(!ativacao)
			{
				if(sprite_index != spr_inimigo_torreta_firewall_hit_desativado)
				{
					image_index = 0;
					sprite_index = spr_inimigo_torreta_firewall_hit_desativado;
				}
				if(image_index > image_number - 1)
				{
					ja_desativado = true;
					estado = "desativado";
				}
				if(vida_atual <= 0)
				{
					estado = "explosao";
				}
			}
		
		break;
	}
	
	case "explosao":
	{
		/*if(sprite_index != spr_explosao_torreta)
		{
			image_angle = 0;
			image_index = 0;
			sprite_index = spr_explosao_torreta;
		}*/
		// 1. Criar Efeito Visual de Explosão
		// instance_create_layer(x, y, layer, obj_efeito_explosao);

		// 2. Criar Dano em Área (Explosão)
		var explosao = instance_create_layer(x, y, layer, obj_dano_explosao);
		
		instance_destroy();
		break;

		// Nota: Como o objeto torreta vai deixar de existir agora, 
		// certifique-se que o "Clean Up" do obj_dano lida com "pai" inexistente 
		// ou defina "explosao.pai = noone" se seu código permitir.
	}
	
	case "desativado":
	{
        // A torreta "dorme".
			ativacao = false;
			show_debug_message("desativou");
	        // Você pode mudar o sprite para um que pareça desligado ou apontando para baixo
			if(ja_desativado = false)
			{
				show_debug_message("entrou na sprite errada")
		        if(sprite_index != spr_inimigo_torreta_firewall_desativada)
				{
					image_index = 0;
					sprite_index = spr_inimigo_torreta_firewall_desativada;
				}
				if(image_index > image_number-1)
				{
					image_index = image_number-1;
					image_speed =0;
				}
				image_angle = lerp(image_angle,-90,0.1);
			}
			else if(ja_desativado = true)
			{
				show_debug_message("entrou na sprite certa")
				if(sprite_index != spr_inimigo_torreta_firewall_desativada)
				{
					image_index = 0;
					sprite_index = spr_inimigo_torreta_firewall_desativada;
					image_index = image_number-1;
					image_speed =0;
				}
			}
			
			break;
	}
		/*else if(ativacao > 0)
		{
			show_debug_message("desativou errado");
			if(sprite_index != spr_inimigo_torreta_firewall_desativada)
			sprite_index = spr_inimigo_torreta_firewall_desativada;
			image_index = image_number - 1;
			image_speed = 0;
		}*/
		
        
        // Se quiser uma animação visual dela desligando, faça aqui.
        // O importante é: ela NÃO atira e NÃO procura o player.
        
	//}
}
