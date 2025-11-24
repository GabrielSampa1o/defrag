/// @description Insert description here
// You can write your code in this editor

var direita, esquerda, pulo;
var chao = place_meeting(x, y + 1, obj_bloco);

direita = keyboard_check(ord("D"));
esquerda = keyboard_check(ord("A"));
pulo = keyboard_check(ord("W"));
//codigo de movementacao
velh = (direita - esquerda) * max_velh;
//caso o jogador aperte pra direita e esquerda ao mesmo tempo o sprite não fica alternando entre direita e esquerda repetidamente
if(direita && esquerda && chao){
	estado = "parado";
}

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
		 }
		
		break;
	}
	#endregion movendo
	
	#region pulando
	case "pulando":{
		//comportamento do estado de pulando
		
	}
	#endregion pulando
}