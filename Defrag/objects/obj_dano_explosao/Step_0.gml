var lista_colisao = ds_list_create();
// Pega todo mundo (Player e Inimigos) que está tocando na explosão
var qtd = instance_place_list(x, y, obj_entidade, lista_colisao, false);
if(sprite_index != spr_explosao_torreta)
{
	image_angle = 0;
	image_index = 0;
	sprite_index = spr_explosao_torreta;
}
for (var i = 0; i < qtd; i++) {
    var alvo = lista_colisao[| i];
    
    if (!instance_exists(alvo)) continue;

    // Se a explosão tocou em alguém que ainda não foi atingido
    if (ds_list_find_index(aplicar_dano, alvo) == -1) {
        
        if (alvo.vida_atual > 0) {
            // Adiciona na lista para não tomar dano de novo no próximo frame
            ds_list_add(aplicar_dano, alvo);
            
            // Aplica o dano e estado de hit
            alvo.estado = "hit";
            alvo.vida_atual -= dano;
            
            // Opcional: Empurrão (Knockback) para longe do centro da explosão
            // var dir = point_direction(x, y, alvo.x, alvo.y);
            // alvo.velh = lengthdir_x(5, dir);
            // alvo.velv = lengthdir_y(5, dir);
        }
    }
}
if(image_index > image_number - 1)
{
	instance_destroy();
}

ds_list_destroy(lista_colisao);