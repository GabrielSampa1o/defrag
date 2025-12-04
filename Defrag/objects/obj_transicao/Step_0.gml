/// @description Insert description here
// You can write your code in this editor

//ja mudei de room
if(mudei){
	alpha -= .02;

}else{ //ainda não mudei de room

	alpha += .02;
}

//quando o alpha passar de 1, mudo de room

if(alpha >= 1){
	
	room_goto(destino);
	
	//controlando a posicao do player
	obj_player.x = destino_x;
	obj_player.y = destino_y;
}


//me destruindo depois de estar transparente e ter mudado de room
if(mudei && alpha <= 0){
	instance_destroy();
}