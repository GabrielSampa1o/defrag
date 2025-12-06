/// @description Insert description here
// You can write your code in this editor



//seleção do menu
sel = 0;
marg_val = 32;
marg_total = 32;
//controlando a pagina do menu
pag = 0;

#region metodos
//desenha menu
desenha_menu = function(_menu){

	//definindo a fonte
	draw_set_font(fnt_menu);


	//alinhando o texto
	define_align(0, 0);


	//desenhando o menu
	//pegando o tamanho do menu
	var _qtd = array_length(_menu);

	//pegando a altura da minha tela
	var _alt = display_get_gui_height();
	
	//pegando a largura
	var _larg = display_get_gui_width();

	//definindo o espaço entre linhas
	var _espaco_y = string_height("I") + 16;
	var _alt_menu = _espaco_y * _qtd;



	//desenhando as opçoes
	for(var i = 0; i < _qtd; i++){
	
		var _cor = c_white, _marg_x = 0;

		//desenhando o item do menu

		var _texto = _menu[i][0];
	
		//checando se a seleão est no tecxto atual
	
		if(menus_sel[pag]== i){
			_cor = c_fuchsia;
			_marg_x = marg_val;
		}
	
		draw_text_color(20 + _marg_x, (_alt / 2) - _alt_menu / 2 + (i * _espaco_y), _texto, _cor, _cor, _cor, _cor, 1)
	}

	//desenha o outro lado do menu(as opções quando ela existirem)
	//rodando pelo meu vetor
	for(var i = 0; i < _qtd; i++){
			//checar se preciso desenhar as opções de fato
			switch(_menu[i][1]){
				case menu_acoes.ajustes_menu: {
					//desenhando as opções do lado dirito
					//salvando o indice de onde estou
					var _indice = _menu[i][3];
					var _txt	= _menu[i][4][_indice];
					
					//eu so posso ir para a esquerda se somente se nao estou no indece 0
					var _esq	= _indice > 0 ? "<< " : "";
					
					//eu so posso ir para a direita se somete se eu ainda nao estou no final do vetor
					var _dir	= _indice < array_length(_menu[i][4]) - 1 ? " >>" : "";
					
					var _cor = c_white;
					//se eu eutoru mechendo na opção eu mudo de cor
					if(alterando && menus_sel[pag] == i) _cor = c_red;
					
					draw_text_color(_larg/2, (_alt / 2) - _alt_menu / 2 + (i * _espaco_y),_esq + _txt + _dir, _cor, _cor, _cor, _cor, 1);
				
					break;
				}
			}
	
	}

	//resetando os meus draw set

	draw_set_font(-1);
	define_align(-1, -1)
}

//controlando o menu
controla_menu = function(_menu){

	//pegando as teclas
	var _up, _down, _avanca, _recua, _left, _right;
	
	var _sel = menus_sel[pag];
	
	static _animar = false;
	
	_up		= keyboard_check_pressed(vk_up);
	_down	= keyboard_check_pressed(vk_down);
	_avanca = keyboard_check_released(vk_enter);
	_recua	= keyboard_check_released(vk_escape);
	_left	= keyboard_check_pressed(vk_left);
	_right	= keyboard_check_pressed(vk_right);
	
	//checando se eu não estou alterando as opções do jogo
	if(!alterando){
		if(_up or _down){
		//mudando o valor do sel
		menus_sel[pag] += _down - _up;
	
		//limitando o sel dentro do vetor
		var _tam = array_length(_menu) -1;
		menus_sel[pag] = clamp(menus_sel[pag], 0, _tam);
		
		//avisando que ele pode animar
		_animar = true;
		
		}
	}else{
		//ou seja- estou alterando as opções
		_animar = false;
		
		//se eu apertar para esquerda ou para a direita, mecho nas opções
		if(_right or _left){
			//achando meu limite
			var _limite = array_length(_menu[_sel][4]) - 1;
			//mudando meu indice dentro do meunu que eu estou
			menus[pag][_sel][3] += _right - _left;
			//garantinfo que eu não vou sair do limite
			menus[pag][_sel][3] = clamp(menus[pag][_sel][3], 0, _limite);
			
			
		}
	}
	


	//o que fazer quando eu apertar o enter em uma opção
	if(_avanca){
		switch(_menu[_sel][1]){
			//caso seja 0, ele roda um método
			case menu_acoes.roda_metodo:  _menu[_sel][2](); break
			//mudar o valor da página
			case menu_acoes.carrega_menu: pag = _menu[_sel][2]; break;
			case menu_acoes.ajustes_menu: 
			
				alterando = !alterando; 
				
				//rodando o método
				if(!alterando){
					
					//salvando o argumento do método
					var _arg = _menu[_sel][3];
					_menu[_sel][2](_arg);
				}
				break;
			
		}
	}
	
	
	//aumentando sempre o marg_val
	if(_animar){
		marg_val = marg_total * valor_ac(ac_margem, _up ^^ _down);
	}
	
}

#endregion

inicia_jogo = function(){
	
	//indo oara a room inicial do jogo
	room_goto(Room1);
}
fechar_jogo = function(){
	game_end();
}


teste = function(){
	show_message("teste");
}

ajusta_tela = function(_valor){

	//checar se eu mandei a tela ficar cheia ou restaurada
	switch(_valor){
		//tela cheia
		case 0: window_set_fullscreen(true); break;
		//restalrado
		case 1: window_set_fullscreen(false); break;
	}
}
ajusta_dificuldade = function(_valor){
	switch(_valor){
		case 0: global.dificuldade	= .5; break;
		case 1: global.dificuldade	= 1; break;
		case 2: global.dificuldade	= 1.5; break;
		case 3: global.dificuldade	= 3;
	}
}

//quando eu apertar enter no iniciar, ele vai rodar um metodo
//quando eu apertar enter no opções ele vai carregar o menu de opções
//quando eu apertar enter no creditos ele carregar os créditos do jogo
//quando eu apertar enter no sair ele vai sair do jogo

//texto - ação - conteudo da ação

menu_principal =	[
						["Iniciar", menu_acoes.roda_metodo, inicia_jogo],
						["Opções", menu_acoes.carrega_menu, menus_lista.opcoes],
						["Sair", menu_acoes.roda_metodo, fechar_jogo]
					];
					

menu_opcoes =	[
						["Tamanho da Janela", menu_acoes.carrega_menu, menus_lista.tela],
						["Dificuldade", menu_acoes.carrega_menu, menus_lista.dificuldade],
						//["Controles", menu_acoes.carrega_menu, menus_lista.dificuldade],
						["Voltar", menu_acoes.carrega_menu, menus_lista.principal]
					];
					
menu_dificuldade = [
						["Dificuldade", menu_acoes.ajustes_menu, teste, 1, ["Fácil", "Normal", "Dificil", "Impossível"]],
						["voltar", menu_acoes.carrega_menu, menus_lista.opcoes]
						
					];
menu_tela = [
						["Tamanho da tela", menu_acoes.ajustes_menu, ajusta_tela, 1, ["Tela cheia", "Janela"]],
						["voltar", menu_acoes.carrega_menu, menus_lista.opcoes]
			];

//salvando todos os meus menus
menus = [menu_principal, menu_opcoes, menu_tela, menu_dificuldade];


//salvando a seleção de cada menu
menus_sel = array_create(array_length(menus), 0);

alterando = false;