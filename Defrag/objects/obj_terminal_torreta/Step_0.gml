if(sprite_index != spr_terminal_torreta_ativado)
{
	image_index = 0;
	sprite_index = spr_terminal_torreta_ativado;
}
// Verifica se o player existe e está perto
if (instance_exists(obj_jogador))
{
    var dist = point_distance(x, y, obj_jogador.x, obj_jogador.y);
    
    // Se está perto (32 pixels) e o terminal ainda está ativo
    if (dist < 32 && ativado == true)
    {
        // Se apertou o botão de interação (ex: tecla E ou Z)
        if (keyboard_check_pressed(ord("E"))) 
        {
            // Checa se tem o item necessário (implemente sua lógica de inventário aqui)
            if (tem_chave == true) 
            {
                ativado = false; // Desativa o terminal
				
                
                // === A MÁGICA DE CONEXÃO ===
                // Percorre TODAS as torretas da sala
                with (obj_inimigo_torreta_firewall)
                {
                    // "other" aqui se refere ao Terminal que está rodando o código
                    if (link_id == other.link_id)
                    {
                        estado = "desativado";
                        // Opcional: Efeito visual na torreta (fumaça, faísca)
                        //instance_create_layer(x, y, "Instances", obj_efeito_desligar); 
                    }
                }
				if(sprite_index != spr_terminal_torreta_desativado)
				{
					image_index = 0;
					sprite_index = spr_terminal_torreta_desativado;
				}
                
                show_debug_message("Torretas do grupo " + string(link_id) + " desativadas!");
				if(image_index > image_number - 1)
				{
					image_speed = 0;
					image_index = image_number -1;
				}
            }
            else
            {
                // Feedback visual ou sonoro que falta a chave
                show_debug_message("Precisa do Cartão de Acesso!");
            }
        }
    }
}