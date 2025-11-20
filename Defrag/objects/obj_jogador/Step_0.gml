/// @description Insert description here
// You can write your code in this editor

var direita, esquerda, pulo;
var chao = place_meeting(x, y + 1, obj_bloco);

direita = keyboard_check(ord("D"));
esquerda = keyboard_check(ord("A"));
pulo = keyboard_check_pressed(ord("K"));


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
		 }else if(pulo || velv !=0){
			estado = "pulando";
			velv = (-max_velv * pulo);
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
	
	
}