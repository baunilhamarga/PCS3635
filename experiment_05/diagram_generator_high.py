import graphviz
import os

# Create output directory if it doesn't exist
output_dir = "images"
os.makedirs(output_dir, exist_ok=True)

# Radius of the circles (fixed size for uniform appearance)
radius = 2.7

# Create state diagram with left-to-right layout
dot_high_level = graphviz.Digraph(engine="dot", graph_attr={"rankdir": "LR", "splines": "true"})

# Define states using high-level names
states_high_level = {
    "inicial": "0: Inicial\n-----------\nAguardando início",
    "preparacao": "1: Preparação\n-----------\nConfigura início do jogo",
    "nova_seq": "2: Nova Sequência\n-----------\nGera nova sequência de jogadas",
    "espera": "3: Espera\n-----------\nAguarda entrada do jogador",
    "registra": "4: Registra\n-----------\nCaptura jogada do jogador",
    "comparacao": "5: Comparação\n-----------\nVerifica jogada",
    "proximo": "6: Próximo\n-----------\nAvança para a próxima jogada",
    "fim_acerto": "A: Fim (ganhou)\n-----------\nJogo concluído com sucesso",
    "fim_erro": "E: Fim (perdeu)\n-----------\nJogo encerrado por erro",
    "fim_timeout": "D: Fim (Timeout)\n-----------\nTempo esgotado, jogo encerrado"
}

# Add nodes with fixed-size circles
for state, label in states_high_level.items():
    dot_high_level.node(state, label, shape="circle", width=f"{radius}", height=f"{radius}", fixedsize="true")

# Define transitions using high-level state names
transitions_high_level = [
    ("inicial", "inicial", "não jogar"),
    ("inicial", "preparacao", "jogar"),
    ("preparacao", "espera", ""),
    ("nova_seq", "espera", ""),
    ("espera", "fim_timeout", "timeout"),
    ("espera", "registra", "jogada"),
    ("registra", "comparacao", ""),
    ("comparacao", "fim_acerto", "jogada correta e sequência completa"),
    ("comparacao", "nova_seq", "jogada correta"),
    ("comparacao", "proximo", "jogada correta"),
    ("comparacao", "fim_erro", "jogada incorreta"),
    ("proximo", "espera", ""),
    ("fim_acerto", "fim_acerto", "não jogar"),
    ("fim_erro", "fim_erro", "não jogar"),
    ("fim_timeout", "fim_timeout", "não jogar"),
    ("fim_acerto", "preparacao", "jogar"),
    ("fim_erro", "preparacao", "jogar"),
    ("fim_timeout", "preparacao", "jogar")
]

# Add transitions to the graph
for src, dst, label in transitions_high_level:
    dot_high_level.edge(src, dst, label)

# Define output paths
output_path = os.path.join(output_dir, "diagrama_moore_high")

# Save as DOT file
dot_high_level.save(output_path + ".dot")

# Convert DOT to PDF and PNG
os.system(f"dot -Tpdf {output_path}.dot -o {output_path}.pdf")
os.system(f"dot -Tpng {output_path}.dot -o {output_path}.png")

print(f"Diagrama salvo em: {output_path}.pdf")
