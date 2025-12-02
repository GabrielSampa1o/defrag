/// @description Limpeza de Memória

// Limpa a referência no pai (se ele ainda existir)
if (instance_exists(pai)) {
    pai.dano = noone;
}

// Destrói a lista da memória RAM (Obrigatório!)
ds_list_destroy(lista_acertados);