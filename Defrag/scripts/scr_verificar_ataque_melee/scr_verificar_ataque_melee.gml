/// @function scr_verificar_ataque_melee(alvo, dist_x, dist_y, xscale)
/// @description Verifica se o alvo está na área de ataque e muda o estado.
/// @param {id}   _alvo      Objeto a procurar (ex: obj_jogador)
/// @param {real} _dist_x    Alcance horizontal do ataque (pixels)
/// @param {real} _dist_y    Alcance vertical (altura da hitbox de detecção)
/// @param {real} _xscale    Direção que o inimigo está olhando (1 ou -1)

function scr_verificar_ataque_melee(_alvo, _dist_x, _dist_y, _xscale){

    // Calcula o centro Y do inimigo para criar a caixa a partir dali
    var _centro_y = y - (sprite_height / 2);

    // Define os pontos do retângulo de detecção
    var _x1 = x; 
    var _x2 = x + (_dist_x * _xscale); // Estica para frente baseado na direção
    
    var _y1 = _centro_y - (_dist_y / 2); // Topo da caixa
    var _y2 = _centro_y + (_dist_y / 2); // Fundo da caixa

    // Verifica colisão
    var _player = collision_rectangle(_x1, _y1, _x2, _y2, _alvo, false, true);

    // Ação
    if (_player) {
        estado = "atacando";
        velh = 0; // Importante: Inimigo para de andar quando decide atacar
        image_index = 0; // Reinicia a animação para o ataque começar do começo
        return true; // Retorna true caso você queira fazer mais alguma coisa no Step
    }
    
    return false;
}