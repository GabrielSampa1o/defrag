/// @description Coleta o Item (Collision com Player)

// 1. Define os textos baseados no tipo de habilidade
var _titulo = "";
var _desc = "";

switch(tipo_habilidade) {
    case "dash":
        global.tem_dash = true;
        _titulo = "DASH OBTIDO!";
        _desc = "Pressione L / Círculo para avançar rapidamente.";
        break;

    case "pulo_duplo":
        global.tem_pulo_duplo = true;
        _titulo = "PULO DUPLO!";
        _desc = "Pressione PULO novamente no ar para alcançar novos lugares.";
        break;

    case "wall_slide":
        global.tem_wall_slide = true;
        _titulo = "ESCALADA!";
        _desc = "Pule contra paredes para deslizar e saltar.";
        break;

    case "espada":
        global.tem_espada = true;
        other.arma_atual = "espada"; // Equipa a espada no Player imediatamente
        _titulo = "LÂMINA DE LUZ!";
        _desc = "Uma arma poderosa. Use Q para trocar.";
        break;
}

// 2. Cria o Popup e Pausa o jogo
// Usamos 'layer' para criar na mesma camada do item, evitando erros se "Instances" não existir
var popup = instance_create_layer(x, y, layer, obj_popup_item); 

popup.titulo = _titulo;
popup.descricao = _desc;

// O PULO DO GATO:
// Passamos o 'sprite_index' atual deste objeto.
// Como configuramos o Create Event para escolher o sprite certo (spr_item_dash, etc.),
// o Popup vai receber e desenhar o sprite correto automaticamente!
popup.sprite_item = sprite_index; 

// 3. Pausa Global
global.game_state = "pausado";

// 4. Destrói o item da fase (para não pegar de novo)
instance_destroy();