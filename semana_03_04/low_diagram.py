import graphviz
import os

# Criar o diretório de saída, se não existir
output_dir = "images"
os.makedirs(output_dir, exist_ok=True)

# Raio dos círculos (tamanho fixo para aparência uniforme)
radius = 2.1

# Criar diagrama de estados com layout da esquerda para a direita
dot_moore = graphviz.Digraph(engine="dot", graph_attr={"rankdir": "LR", "splines": "true"})

# Dicionário de estados (nome interno -> label com sinais acionados)
states_moore = {
    "inicial": (
        "inicial\n-----------\n"
        "zeraE=1, zeraR=1,\nzeraS=1,\nzera_metricas=1"
    ),
    "preparacao": (
        "preparacao\n-----------\n"
        "zeraE=1, carregaS=1,\n"
        "nivel_uc=nivel,\nmemoria_uc=memoria"
    ),
    "escreve": (
        "escreve\n-----------\n"
        "ram_escreve=1,\ncontaE=1"
    ),
    "espera_escrita": (
        "espera_escrita\n-----------\n"
        "aguarda tem_jogada=1"
    ),
    "zera_contador": (
        "zera_contador\n-----------\n"
        "zeraE=1\n(aguarda jogar=1)"
    ),
    "nova_seq": (
        "nova_seq\n-----------\n"
        "zeraE=1,\ncontaS=1,\nzeraJ=1,\nzeraT=1"
    ),
    "mostra_leds": (
        "mostra_leds\n-----------\n"
        "controla_leds=1,\ncontaT_leds=1,\n"
        "fase_preview=1"
    ),
    "mostrou_led": (
        "mostrou_led\n-----------\n"
        "contaE=1,\nzeraT_leds=1,\n"
        "fase_preview=1"
    ),
    "espera_led": (
        "espera_led\n-----------\n"
        "contaT_leds=1"
        # fase_preview=1 não é ativado nesse estado, segundo o Verilog
    ),
    "zera_timeout": (
        "zera_timeout\n-----------\n"
        "zeraT_leds=1,\nfase_preview=1"
    ),
    "comecar_rodada": (
        "comecar_rodada\n-----------\n"
        "zeraT_leds=1,\nfase_preview=1"
    ),
    "espera": (
        "espera\n-----------\n"
        "contaT=1\n(aguarda tem_jogada=1\nou timeout=1)"
    ),
    "registra": (
        "registra\n-----------\n"
        "registraR=1"
    ),
    "comparacao": (
        "comparacao\n-----------\n"
        "contaS=1,\n(decide erro/acerto)"
    ),
    "proximo": (
        "proximo\n-----------\n"
        "contaE=1,\ncontaJ=1,\nzeraT=1"
    ),
    "fim_acerto": (
        "fim_acerto\n-----------\n"
        "ganhou=1,\npronto=1,\nzeraJ=1,\nzeraT=1"
    ),
    "fim_erro": (
        "fim_erro\n-----------\n"
        "perdeu=1,\npronto=1,\nzeraJ=1,\nzeraT=1"
    ),
    "fim_timeout": (
        "fim_timeout\n-----------\n"
        "perdeu=1,\npronto=1,\n"
        "deu_timeout=1,\nzeraJ=1,\nzeraT=1"
    ),
    "metricas_perder": (
        "metricas_perder\n-----------\n"
        "conta_perder=1"
    ),
    "metricas_ganhar": (
        "metricas_ganhar\n-----------\n"
        "conta_ganhar=1"
    ),
}

# Adicionar estados (nós) com círculos de tamanho fixo
for state, label in states_moore.items():
    dot_moore.node(state, label, shape="circle", width=f"{radius}", height=f"{radius}", fixedsize="true")

# Transições baseadas na lógica Eprox do código (usando os sinais explicitamente)
transitions_moore = [
    # (origem, destino, "condição")
    ("inicial", "inicial", "jogar=0"),
    ("inicial", "preparacao", "jogar=1"),

    ("preparacao", "espera_escrita", "vai_escrever=1"),
    ("preparacao", "mostra_leds", "vai_escrever=0"),

    ("escreve", "zera_contador", "fimE=1"),
    ("escreve", "espera_escrita", "fimE=0"),

    ("espera_escrita", "escreve", "tem_jogada=1"),
    ("espera_escrita", "espera_escrita", "tem_jogada=0"),

    ("zera_contador", "mostra_leds", "jogar=1"),
    ("zera_contador", "zera_contador", "jogar=0"),

    ("nova_seq", "espera_led", "sempre"),

    ("mostra_leds", "comecar_rodada", "timeoutL=1 & fimE=1"),
    ("mostra_leds", "mostrou_led", "timeoutL=1 & fimE=0"),
    ("mostra_leds", "mostra_leds", "timeoutL=0"),

    ("mostrou_led", "espera_led", "sempre"),

    ("espera_led", "comecar_rodada", "menorS=1"),
    ("espera_led", "zera_timeout", "menorS=0 & timeoutL=1"),
    ("espera_led", "espera_led", "menorS=0 & timeoutL=0"),

    ("zera_timeout", "mostra_leds", "sempre"),

    ("comecar_rodada", "espera", "sempre"),

    ("espera", "fim_timeout", "timeout=1"),
    ("espera", "registra", "timeout=0 & tem_jogada=1"),
    ("espera", "espera", "timeout=0 & tem_jogada=0"),

    ("registra", "comparacao", "sempre"),

    ("comparacao", "fim_acerto", "igualE=1 & fimE=1"),
    ("comparacao", "nova_seq", "igualE=1 & fimE=0 & pare=1"),
    ("comparacao", "proximo", "igualE=1 & fimE=0 & pare=0"),
    ("comparacao", "fim_erro", "igualE=0"),

    ("proximo", "espera", "sempre"),

    ("fim_acerto", "metricas_ganhar", "jogar=1"),
    ("fim_acerto", "fim_acerto", "jogar=0"),

    ("fim_erro", "metricas_perder", "jogar=1"),
    ("fim_erro", "fim_erro", "jogar=0"),

    ("fim_timeout", "metricas_perder", "jogar=1"),
    ("fim_timeout", "fim_timeout", "jogar=0"),

    ("metricas_perder", "preparacao", "sempre"),
    ("metricas_ganhar", "preparacao", "sempre"),
]

# Adicionar transições ao grafo
for src, dst, label in transitions_moore:
    dot_moore.edge(src, dst, label)

# Definir caminhos de saída
output_path = os.path.join(output_dir, "diagrama_low_uc")

# Salvar como arquivo DOT
dot_moore.save(output_path + ".dot")

# Converter DOT para PDF e PNG
os.system(f"dot -Tpdf {output_path}.dot -o {output_path}.pdf")
os.system(f"dot -Tpng {output_path}.dot -o {output_path}.png")

print(f"Diagrama salvo em: {output_path}.pdf e {output_path}.png")
