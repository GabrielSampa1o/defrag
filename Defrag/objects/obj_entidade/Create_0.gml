/// @description Insert description here
// You can write your code in this editor
invencivel = false;

delay = 0;

vida_max = 1;
vida_atual = vida_max;

velh = 0;
velv = 0;
mid_velh = 0;

max_velh = 1;
max_velv = 1;

ataque = 1;

xscale = 1;

mostra_estado = false;
img_spd = 40;

estado = "parado";

empurrao_h = 0; // Força horizontal externa
empurrao_v = 0; // Força vertical externa
hit_timer = 0;  // Tempo atordoado

// Método para receber o empurrão (Já tínhamos feito, mas confirmando)
aplicar_knockback = function(_forca, _dir_x, _dir_y) {
    var forca_final = _forca / massa;
    // Define a velocidade do empurrão
    empurrao_h = lengthdir_x(forca_final, point_direction(0, 0, _dir_x, _dir_y));
    empurrao_v = lengthdir_y(forca_final, point_direction(0, 0, _dir_x, _dir_y));
    
    // Força o estado de hit (se a entidade tiver máquina de estados)
    if (variable_instance_exists(id, "estado")) {
        estado = "hit";
        image_index = 0;
    }
}



