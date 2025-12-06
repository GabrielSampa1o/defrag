/// @description Lógica de Dano e Colisão (Final)

// 1. LISTA TEMPORÁRIA
var lista_colisao = ds_list_create();
var qtd = instance_place_list(x, y, obj_entidade, lista_colisao, false);

// 2. LOOP DE COLISÃO
for (var i = 0; i < qtd; i++) {
    var vitima = lista_colisao[| i];
    
    // --- FILTROS DE SEGURANÇA ---
    if (vitima.id == pai.id) continue;
    if (vitima.invencivel) continue;
    if (vitima.vida_atual <= 0) continue;
    
    // Verifica se já bateu nesta vítima (Memória)
    if (ds_list_find_index(lista_acertados, vitima) != -1) continue; 
    
    // --- VERIFICAÇÃO DE TIMES ---
    var pode_bater = false;
    
    // Pai é PLAYER -> Bate em Inimigos
    if (pai.object_index == obj_jogador) {
        if (object_is_ancestor(vitima.object_index, obj_inimigo_pai)) pode_bater = true;
    }
    // Pai é INIMIGO -> Bate no Player
    else if (object_is_ancestor(pai.object_index, obj_inimigo_pai)) {
        if (vitima.object_index == obj_jogador) pode_bater = true;
    }
    
    // --- APLICANDO O DANO ---
    if (pode_bater) {
        
        // 1. Marca como atingido
        ds_list_add(lista_acertados, vitima);
        
        // 2. Tira Vida e Muda Estado
        vitima.vida_atual -= dano;
        vitima.estado = "hit";
        vitima.image_index = 0;
        
        // [CORREÇÃO] LÓGICA DIFERENCIADA DE INVENCIBILIDADE
        
        // SE A VÍTIMA FOR O JOGADOR:
        // Precisa de invencibilidade para não morrer com 1 golpe múltiplo
        if (vitima.object_index == obj_jogador) {
            vitima.invencivel = true;
            
            if (variable_instance_exists(vitima, "invencivel_timer")) {
                vitima.tempo_invencivel = vitima.invencivel_timer;
            } else {
                vitima.tempo_invencivel = 60; 
            }
        }
        // SE A VÍTIMA FOR INIMIGO:
        // NÃO fica invencível. Permite combos (Jab + Direto pegarem em sequência).
        else {
            vitima.invencivel = false;
            vitima.image_alpha = 1; // Garante que ele está visível
        }
        
        // 3. EFEITOS ESPECÍFICOS (Screen Shake)
        if (tremor_hit > 0) {
            screenshake(tremor_hit);
        }
        
        // Efeitos extras do Player (Pogo, etc - Opcional)
        if (pai.object_index == obj_jogador) {
            /*
            with (pai) {
                // ... lógica de pogo se quiser restaurar ...
            }
            */
        }
    }
}

// Limpa memória
ds_list_destroy(lista_colisao);

// Destruição
if (morrer) {
    instance_destroy();
} else {
    if (!instance_exists(pai)) {
        instance_destroy();
    }
}