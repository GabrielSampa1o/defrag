/// @description Insert description here
// You can write your code in this editor

var direita, esquerda, pulo, dash;
var chao = place_meeting(x, y + 1, obj_bloco);

direita = keyboard_check(ord("D"));
esquerda = keyboard_check(ord("A"));
pulo = keyboard_check_pressed(ord("K"));
dash = keyboard_check_pressed(ord("L"));


// Verifica se SOLTOU a tecla K ou SOLTOU o botão do comando
var pulo_solto = keyboard_check_released(ord("K"));

// LÓGICA DO BUFFER E COYOTE (NOVO) ---

// Controle do Coyote Time (Estou no chão? Enche o timer. Saí? Diminui.)
if (chao) {
	pulos_restantes = max_pulos;
    coyote_timer = coyote_max;
} else {
	// Se caí da plataforma sem pular, perco o primeiro pulo
    if (coyote_timer <= 0 && pulos_restantes == max_pulos) {
        pulos_restantes = max_pulos - 1;
    }
    if (coyote_timer > 0) coyote_timer--;
}

// Controle do Jump Buffer (Apertei pulo? Enche o timer. O tempo passa? Diminui.)
if (pulo) {
    buffer_timer = buffer_max;
}
if (buffer_timer > 0) buffer_timer--;

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


// --- MECÂNICA DE PULO VARIÁVEL (NOVO) ---
// Se o jogador SOLTOU o botão E está subindo (velv negativa)
if (pulo_solto && velv < 0) {
    velv *= 0.5; // Corta a velocidade de subida em 50%
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
	// CONDIÇÃO DE PULO (Buffer + Coyote)
        if (buffer_timer > 0 && coyote_timer > 0) {
            estado = "pulando";
            velv = -max_velv;
            image_index = 0;
			
            pulos_restantes--; // GASTA O PRIMEIRO PULO
			
            // Importante: Zerar os timers para não pular de novo sem querer
            buffer_timer = 0;
            coyote_timer = 0;
        }
        // Condição de Cair (Só cai se acabou o coyote time)
        else if (!chao && coyote_timer <= 0) {
             estado = "pulando"; // Ou estado "caindo" se tiver
             image_index = 0;
        }
        // Condição de Mover
        else if (velh != 0) {
            estado = "movendo";
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
// CONDIÇÃO DE PULO (Buffer + Coyote)
        if (buffer_timer > 0 && coyote_timer > 0) {
            estado = "pulando";
            velv = -max_velv;
            image_index = 0;
            
			pulos_restantes--; // GASTA O PRIMEIRO PULO
			
            // Zera os timers
            buffer_timer = 0;
            coyote_timer = 0;
        }
        // Condição de Cair
        else if (!chao && coyote_timer <= 0) {
             estado = "pulando";
             image_index = 0;
        }
        // Condição de Parar
        else if (abs(velh) < .1) {
            estado = "parado";
            velh = 0;
        }
        else if (dash && dash_timer <= 0) {
            estado = "dash";
            image_index = 0;
        }
		
		break;
	}
	#endregion movendo
	#region pulado
	case "pulando":{
	
		// --- LÓGICA DO PULO DUPLO ---
        // Se apertei pulo (buffer) E tenho pulos sobrando
        if (buffer_timer > 0 && pulos_restantes > 0) {
            velv = -max_velv; // Impulsiona de novo
            pulos_restantes--; // Gasta o pulo extra
            image_index = 0;   // Reinicia a animação
            buffer_timer = 0;  // Consome o input
            
            // Opcional: Criar um efeito visual aqui
            // instance_create_layer(x, y, layer, obj_efeito_pulo);
        }
		
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
			velv = 0;
		}
		
		break;
	}
	#endregion pulando
	
#region dash
    case "dash":{
        sprite_index = spr_jogador_dash; 
        
        // Mantém a velocidade constante durante o dash
        mid_velh = image_xscale * dash_vel; 
        velh = 0; 
        velv = 0; 

        // --- MELHORIA: DASH CANCEL (Pular durante o dash) ---
        // Verifica se apertou pulo (buffer) E se pode pular (chao ou coyote)
        // Nota: Se quiseres que ele possa pular do dash mesmo no ar (sem chão), 
        // remove a parte "&& (chao || coyote_timer > 0)"
        if (buffer_timer > 0 && (chao || coyote_timer > 0)) {
            
            estado = "pulando";
            velv = -max_velv; // Força do pulo
            
            // O SEGREDO DO "FEELING":
            // Passamos a velocidade do dash (mid_velh) para a velocidade normal (velh)
            // Assim ele sai do dash voando, em vez de parar no ar.
            velh = mid_velh; 
            mid_velh = 0;
            
            buffer_timer = 0; // Consome o comando de pulo
            image_index = 0;
            break; // Sai do switch imediatamente
        }
        // ----------------------------------------------------

        // Saindo do estado normalmente (quando a animação acaba)
        if (image_index >= image_number - 1 || !chao){
            estado = "parado";
            
            // Aqui escolhes: queres que ele pare bruscamente ou deslize?
            // mid_velh = 0; // Para bruscamente (estilo clássico)
            velh = mid_velh; // Continua o movimento (estilo fluido)
            mid_velh = 0;
            
            velv = 0; 
            dash_timer = dash_delay;
        }
        break;
    }
    #endregion
	
	
	
	
}