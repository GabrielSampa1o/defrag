/// @description Insert description here
// You can write your code in this editor


// Animação de entrada (Pop)
alpha = lerp(alpha, 1, 0.1);
scale = lerp(scale, 1, 0.1);

// Fecha o popup
var confirmar = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(0, gp_face1);

if (confirmar && alpha > 0.9) {
    // Despausa o jogo
    global.game_state = "jogando";
    // Restaura velocidade do player (opcional)
    instance_destroy();
}




