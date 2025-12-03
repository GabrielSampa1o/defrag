//1. movimento
image_angle = direction;

//2. colisão com paredes
if (place_meeting(x,y,obj_bloco))
{
	instance_destroy();
	exit;
}

//3. logica de dano (adaptada de obj_dano)
//criando a lista de quem o projétilestá tocando agora
var lista_colisao = ds_list_create();
var qtd = instance_place_list(x,y, obj_entidade,lista_colisao,false);

for(var i = 0; i< qtd; i++)
{
	var alvo = lista_colisao[|i];
	
	//se o alvo não existe ou é o próprio pai (a torreta), ignora
	if(!instance_exists(alvo)) continue;
	if(pai != noone && alvo == pai) continue;
	
	//verificação de parentesco (inimigo não acerta inimigo)
	var pai_do_alvo = object_get_parent(alvo.object_index);
	var pai_do_meu_pai = noone;
	if (pai != noone) pai_do_meu_pai = object_get_parent(pai.object_index);
	
	//se forem de times diferentes
	if(pai_do_alvo != pai_do_meu_pai)
	{
		//verifica se já não acertou (pra não dar hit duplo no mesmo frame)
		if(ds_list_find_index(lista_acertados, alvo) == -1)
		{
			if(alvo.vida_atual > 0)
			{
				//aplica o dano
				ds_list_add(lista_acertados,alvo);
				alvo.vida_atual -= dano;
				alvo.estado = "hit";
				//morre ao acertar o alvo
				instance_destroy();
			}
		}
	}
}

ds_list_destroy(lista_colisao);
