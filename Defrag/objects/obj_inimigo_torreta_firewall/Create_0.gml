// Inherit the parent event
event_inherited();

//configurações da torreta
vida_max = 20;
vida_atual = vida_max;
raio_alerta = 250; //distancia para começar atirar
timer_tiro =0;
delay_tiro =60; //1 segundo de tempo entre os tiros
ataque = 0;
//variável de conexão com o terminal (0 é padrão)
link_id = 0;
ativacao = true;
ja_desativado = false;

estado = "vigilante";