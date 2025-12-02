/// @description Monitoramento de Vida

// Verifica se a vida acabou e força a entrada no estado de morte
if (vida_atual <= 0 && estado != "morto") {
    estado = "morto";
    
    // Opcional: Zerar velocidade aqui garante que ele pare no exato frame que a vida zera,
    // antes mesmo de entrar no case "morto" no próximo frame.
    velh = 0;
    mid_velh = 0; 
    
    image_index = 0;
}