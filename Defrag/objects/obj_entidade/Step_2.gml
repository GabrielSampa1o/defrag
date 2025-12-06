/// @description Sistema de Colisão e Movimento Final

// =========================================================
// 1. INICIALIZAÇÃO SEGURA DE VARIÁVEIS
// =========================================================
// Definimos 'baixar' como falso por padrão para garantir que inimigos
// e outros objetos não travem ao tentar ler essa variável.
var baixar = false;

// =========================================================
// 2. LEITURA DE INPUT (APENAS PLAYER)
// =========================================================
// Verificamos se quem está rodando este código é o Jogador.
// Se for, lemos o controle/teclado. Se for Slime, ignora.
if (object_index == obj_jogador) {
    // Certifique-se de que 'gamepad_slot' foi criado no Create do Player
    // Se der erro aqui, é porque o Player não tem essa variável.
    baixar = keyboard_check(ord("S")) || gamepad_axis_value(gamepad_slot, gp_axislv) > 0.5;
}

// =========================================================
// 3. PREPARAÇÃO DO MOVIMENTO
// =========================================================
// Soma a velocidade do teclado/IA (velh) com a inércia/empurrão (mid_velh)
var velh_final = velh + mid_velh;

var _dir_h = sign(velh_final);
var _dir_v = sign(velv);

// =========================================================
// 4. COLISÃO HORIZONTAL (Paredes)
// =========================================================
repeat(abs(velh_final)) {
    
    // Verifica Parede Sólida
    if (place_meeting(x + _dir_h, y, obj_bloco)) {
        velh = 0;
        mid_velh = 0;
        break;
    }
    
    x += _dir_h;
}

// =========================================================
// 5. COLISÃO VERTICAL (Paredes + Plataformas)
// =========================================================
repeat(abs(velv)) {
    
    // A. Verifica Parede Sólida (Sempre para)
    if (place_meeting(x, y + _dir_v, obj_bloco)) {
        velv = 0;
        break;
    }
    
    // B. Verifica Plataforma (One-Way) - obj_plataforma
    // Só checa colisão se:
    // 1. Estou caindo (_dir_v > 0)
    // 2. NÃO estou segurando para baixo (!baixar)
    if (_dir_v > 0 && !baixar) {
        
        var plat = instance_place(x, y + _dir_v, obj_plataforma);
        
        if (plat != noone) {
            // O SEGREDO: Só colide se o meu pé (bbox_bottom) estiver 
            // acima ou na linha do topo da plataforma antes de entrar nela.
            if (bbox_bottom <= plat.bbox_top) {
                velv = 0;
                break;
            }
        }
    }
    
    y += _dir_v;
}