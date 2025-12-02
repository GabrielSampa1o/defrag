/// @description Insert description here
// You can write your code in this editor

var outro;
var outro_lista = ds_list_create();
var quantidade = instance_place_list(x, y, obj_entidade, outro_lista, 0);


//adicionando todo mundo que toquei na lista de dano
for(var i=0; i < quantidade; i++){

	//checando o atual
	
	var atual = outro_lista[| i];
	
	
	//checando se o atual esta invenciel
	if(atual.invencivel){
		continue;
	}
	
	//show_message(object_get_name(atual.object_index));
	//checando se a colisão, n é com um filho do meu pai
	if(object_get_parent(atual.object_index) != object_get_parent(pai.object_index)){
	
		//isso só vai rodar se eu puder dar dano
		
		//checar se eu realmente posso dar dano
		
		//checar se o atual já está na lista
		var pos = ds_list_find_index(aplicar_dano, atual);
		
		if (pos == -1){
			//o atual não está na minha lista de dano
			//adiciono o atual a lista de dano
			ds_list_add(aplicar_dano, atual);
			
		}
	}
}


//aplicano o dano
var tam = ds_list_size(aplicar_dano);
for(var i = 0; i < tam; i++){
	outro = aplicar_dano [| i].id;
	if(outro.vida_atual > 0){
		
		if(outro.delay <=0){
			outro.estado = "hit";
			outro.image_index = 0;
		}
		
		outro.vida_atual -= dano;
		
		//preciso checar se estou acertando o inimigo
		//checando se sou filho do inimigo pai
		if(object_get_parent(outro.object_index) == obj_inimigo_pai){
			//show_debug_message("sou inimigo")
			
			//dando um screenshake apenas para inimigos
			screenshake(2); 
			
			//garantindo que o inimigo morra
			if(outro.vida_atual <=0){
				outro.estado = "morto";
			}

		}
		
	}	
}

//destruindo minhas listas
ds_list_destroy(aplicar_dano);
ds_list_destroy(outro_lista);

if(morrer){
	instance_destroy();
}else{
	y = pai.y - pai.sprite_height/4;
	
	if(quantidade){
		instance_destroy()
	}
}





