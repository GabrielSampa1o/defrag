/// @description Insert description here
// You can write your code in this editor

var direita, esquerda, pulo, dash;
var chao = place_meeting(x, y + 1, obj_bloco);

direita = keyboard_check(ord("D"));
esquerda = keyboard_check(ord("A"));
pulo = keyboard_check_pressed(ord("K"));
dash = keyboard_check_pressed(ord("L"));

//diminuindo o dash timer
if(dash_timer > 0) dash_timer--;

//codigo de movementacao
velh = (direita - esquerda) * max_velh;

//aplicando gravidade
if(!chao){
	if(velv < max_velv * 2){
		velv += GRAVIDADE * massa;
	}	
}


//iniciando a máquina de estados
switch(estado){
	
	#region parado
	case "parado":{
	
		//parando o mid_velh
		mid_velh = 0;
		
		//comportamento do estado
		sprite_index = spr_jogador_parado
		
		//condição de troca de estado
		//movendo
		if (direita || esquerda){
			estado = "movendo";
		}else if(pulo || velv !=0){
			estado = "pulando";
			velv = (-max_velv * pulo);
			image_index = 0;
		}else if(dash && dash_timer	<= 0 ){
			estado = "dash";
			image_index = 0;
		}
		
		break;
	}
	#endregion parado
	
	#region	movendo
	case "movendo":{
		
		//comportamento do estado de movimento
		sprite_index = spr_jogador_correndo;
		
		// condicao de troca de estado
		 //parado
		 if (abs(velh) < .1){
			estado = "parado";
			velh = 0;
		 }else if(pulo || !chao){
			estado = "pulando";
			velv = (-max_velv * pulo);
			image_index = 0;
		}else if(dash){
			estado = "dash";
			image_index = 0;
		}
		
		break;
	}
	#endregion movendo
	#region pulado
	case "pulando":{
	
		
		//personagem caindo
		if(velv > 0){
			sprite_index = spr_jogador_caindo;
			if(image_index >= image_number -1){
				image_index = image_number -1;
			}
		}else{
			//personagem pulando
			sprite_index = spr_jogador_pulando;
			//garantindo que a animação não se repita
			if(image_index >= image_number -1){
				image_index = image_number -1;
			}
		}
		
		//condiçao de troca de estado
		if(chao){
			estado = "parado";
		}
		
		break;
	}
	#endregion pulando
	
	#region dash
	case "dash":{
		sprite_index = spr_jogador_dash;
		
		//velocidade
		mid_velh = image_xscale * dash_vel;
		velh = 0;
		//saindo do estado
		if (image_index >= image_number -1 || !chao){
			estado = "parado";
			mid_velh = 0;
			
			//resetando o timer do dash
			dash_timer = dash_delay;
		}
		
	
		break;
	}
	
	#endregion dash
	
	
	
	
}