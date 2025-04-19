import graphviz
import os

# Criar o diretório de saída, se não existir
output_dir = "images"
os.makedirs(output_dir, exist_ok=True)

# Raio dos círculos (tamanho fixo para aparência uniforme)
radius = 2.1

# Criar diagrama de estados com layout da esquerda para a direita
dot_higher = graphviz.Digraph(engine="dot", graph_attr={"rankdir": "LR", "splines": "true"})

# Dicionário de estados (versão mais "alto nível")
states_higher = {
    "inicial": (
        "Inicial\n-----------\n"
        "Zera contadores,\nZera registros,\nZera métricas"
    ),
    "preparacao": (
        "Preparação\n-----------\n"
        "Zera E,\nCarrega nível,\nCarrega memória"
    ),
    "escreve": (
        "Escrevendo na RAM\n-----------\n"
        "Atualiza dados,\nIncrementa E"
    ),
    "espera_escrita": (
        "Aguarda Sinal de Escrita\n-----------\n"
        "Aguarda jogada do usuário\npara continuar escrita"
    ),
    "zera_contador": (
        "Zera Contador\n-----------\n"
        "Zera E\nAguarda apertar JOGAR"
    ),
    "nova_seq": (
        "Nova Sequência\n-----------\n"
        "Zera E,\nIncrementa contador S,\nZera Jogadas,\nZera Timeout"
    ),
    "mostra_leds": (
        "Exibindo LEDs\n-----------\n"
        "Controla LEDs,\nContador LEDs,\nFase de Preview"
    ),
    "mostrou_led": (
        "LED Exibido\n-----------\n"
        "Incrementa E,\nZera timer LEDs,\nPermanece Preview"
    ),
    "espera_led": (
        "Aguardando LED\n-----------\n"
        "Incrementa timer LEDs"
    ),
    "zera_timeout": (
        "Zerando Timeout\n-----------\n"
        "Reseta timer LEDs,\nAinda em Preview"
    ),
    "comecar_rodada": (
        "Iniciando Rodada\n-----------\n"
        "Reseta timer LEDs,\nFinal da fase de Preview"
    ),
    "espera": (
        "Esperando Jogada\n-----------\n"
        "Contador Timeout\n(aguarda jogada do usuário\nou estouro de tempo)"
    ),
    "registra": (
        "Registrando Jogada\n-----------\n"
        "Armazena jogada \ndo usuário"
    ),
    "comparacao": (
        "Comparando Jogada\n-----------\n"
        "Verifica acerto/erro,\nIncrementa contador S\ncaso esteja correto"
    ),
    "proximo": (
        "Próximo Passo\n-----------\n"
        "Incrementa E,\nIncrementa jogadas,\nZera Timeout"
    ),
    "fim_acerto": (
        "Fim (Acerto)\n-----------\n"
        "Ganhou rodada,\nSinaliza pronto,\nZera jogadas,\nZera Timeout"
    ),
    "fim_erro": (
        "Fim (Erro)\n-----------\n"
        "Perdeu rodada,\nSinaliza pronto,\nZera jogadas,\nZera Timeout"
    ),
    "fim_timeout": (
        "Fim (Timeout)\n-----------\n"
        "Tempo esgotado,\nSinaliza pronto,\nZera jogadas,\nZera Timeout"
    ),
    "metricas_perder": (
        "Atualiza Métricas (Perda)\n-----------\n"
        "Incrementa contador de\nderrotas"
    ),
    "metricas_ganhar": (
        "Atualiza Métricas (Vitória)\n-----------\n"
        "Incrementa contador de\nvitórias"
    ),
}

# Adicionar estados (nós) com círculos de tamanho fixo
for state, label in states_higher.items():
    dot_higher.node(state, label, shape="circle", width=f"{radius}", height=f"{radius}", fixedsize="true")

# Transições em linguagem mais amigável
transitions_higher = [
    # (origem, destino, "condição")
    ("inicial", "inicial", "Botão JOGAR não pressionado"),
    ("inicial", "preparacao", "Botão JOGAR pressionado"),

    ("preparacao", "espera_escrita", "Precisa salvar na RAM?"),
    ("preparacao", "mostra_leds", "Não precisa salvar na RAM"),

    ("escreve", "zera_contador", "Concluiu contagem\n(Ex.: fimE=1)"),
    ("escreve", "espera_escrita", "Ainda falta escrita\n(Ex.: fimE=0)"),

    ("espera_escrita", "escreve", "Chegou jogada do usuário"),
    ("espera_escrita", "espera_escrita", "Não chegou jogada"),

    ("zera_contador", "mostra_leds", "Botão JOGAR pressionado"),
    ("zera_contador", "zera_contador", "Botão JOGAR não pressionado"),

    ("nova_seq", "espera_led", "Transição imediata"),

    ("mostra_leds", "comecar_rodada", "Timer Leds=OK e\nE chegou ao fim"),
    ("mostra_leds", "mostrou_led", "Timer Leds=OK e\nAinda não chegou ao fim"),
    ("mostra_leds", "mostra_leds", "Aguardando tempo Leds\n(TimeoutL=0)"),

    ("mostrou_led", "espera_led", "Transição imediata"),

    ("espera_led", "comecar_rodada", "Já exibiu todos os Leds\n(Ex.: menorS=1)"),
    ("espera_led", "zera_timeout", "Timer Leds terminou\nmas faltam Leds"),
    ("espera_led", "espera_led", "Não terminou Leds e\ntimer não esgotou"),

    ("zera_timeout", "mostra_leds", "Transição imediata"),

    ("comecar_rodada", "espera", "Transição imediata"),

    ("espera", "fim_timeout", "Tempo esgotado\n(Timeout=1)"),
    ("espera", "registra", "Jogador fez jogada"),
    ("espera", "espera", "Sem jogada e sem timeout"),

    ("registra", "comparacao", "Transição imediata"),

    ("comparacao", "fim_acerto", "Jogada correta e\nfim da sequência"),
    ("comparacao", "nova_seq", "Jogada correta mas\nnão terminou e 'pare'=1"),
    ("comparacao", "proximo", "Jogada correta mas\nnão terminou e 'pare'=0"),
    ("comparacao", "fim_erro", "Jogada incorreta"),

    ("proximo", "espera", "Transição imediata"),

    ("fim_acerto", "metricas_ganhar", "Botão JOGAR pressionado"),
    ("fim_acerto", "fim_acerto", "Aguardando novo jogo"),

    ("fim_erro", "metricas_perder", "Botão JOGAR pressionado"),
    ("fim_erro", "fim_erro", "Aguardando novo jogo"),

    ("fim_timeout", "metricas_perder", "Botão JOGAR pressionado"),
    ("fim_timeout", "fim_timeout", "Aguardando novo jogo"),

    ("metricas_perder", "preparacao", "Transição imediata"),
    ("metricas_ganhar", "preparacao", "Transição imediata"),
]

# Adicionar transições ao grafo
for src, dst, label in transitions_higher:
    dot_higher.edge(src, dst, label)

# Definir caminhos de saída
output_path = os.path.join(output_dir, "diagrama_high_uc")

# Salvar como arquivo DOT
dot_higher.save(output_path + ".dot")

# Converter DOT para PDF e PNG
os.system(f"dot -Tpdf {output_path}.dot -o {output_path}.pdf")
os.system(f"dot -Tpng {output_path}.dot -o {output_path}.png")

print(f"Diagrama salvo em: {output_path}.pdf e {output_path}.png")
