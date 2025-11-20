
//cogido da camera ao lado da barra de vida e energia
#region mini_camera
// direção do player: -1 esquerda, +1 direita
var dir_x = obj_jogador.direita - obj_jogador.esquerda;

// offset baseado na direção
var ox = dir_x * 5;
var oy = -21;

// pegar a câmera
var cam = view_get_camera(1);

var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);

// calcular posição final
var tx = obj_jogador.x - vw/2 + ox;
var ty = obj_jogador.y - vh/2 + oy;

// limitar
tx = clamp(tx, 0, room_width - vw);
ty = clamp(ty, 0, room_height - vh);

// aplicar
camera_set_view_pos(cam, tx, ty);
#endregion mini_camera
