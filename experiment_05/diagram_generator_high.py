import graphviz
import os

# Create output directory if it doesn't exist
output_dir = "images"
os.makedirs(output_dir, exist_ok=True)

# Raidus of the circles
radius = 2.8

# Create state diagram with left-to-right layout
dot_moore = graphviz.Digraph(engine="dot", graph_attr={"rankdir": "LR", "splines": "true"})

# Define states with identifiers and high-level signal descriptions
states_moore = {
    "inicial": "0: Inicial\nZera contador de endereço\nZera registrador",
    "preparacao": "1: Preparação\nZera contador de endereço\nZera contador\nde sequência",
    "nova_seq": "2: Nova Seq\nZera contador de endereço",
    "espera": "3: Espera\nIncrementa temporizador",
    "registra": "4: Registra\nArmazena jogada",
    "comparacao": "5: Comparação",
    "proximo": "6: Próximo\nIncrementa contador\nde endereço",
    "proxima_seq": "7: Próxima Seq\nIncrementa contador\nde sequência",
    "fim_acerto": "A: Fim (Acertou)\nSinaliza jogo concluído\nAtiva saída de sucesso",
    "fim_erro": "E: Fim (Errou)\nSinaliza jogo concluído\nAtiva saída de erro",
    "fim_timeout": "D: Fim (Timeout)\nSinaliza jogo concluído\nAtiva saída de timeout"
}

# Add nodes with fixed-size circles
for state, label in states_moore.items():
    dot_moore.node(state, label, shape="circle", width=f"{radius}", height=f"{radius}", fixedsize="true")

# Define transitions
transitions_moore = [
    ("inicial", "preparacao", "jogar"),
    ("preparacao", "espera", ""),
    ("nova_seq", "espera", ""),
    ("espera", "fim_timeout", "timeout"),
    ("espera", "registra", "jogada"),
    ("registra", "comparacao", ""),
    ("comparacao", "fim_acerto", "igualE e fimE"),
    ("comparacao", "proxima_seq", "igualE e igualL"),
    ("comparacao", "proximo", "igualE"),
    ("comparacao", "fim_erro", "não igualE"),
    ("proximo", "espera", ""),
    ("proxima_seq", "nova_seq", ""),
    ("fim_acerto", "preparacao", "jogar"),
    ("fim_erro", "preparacao", "jogar"),
    ("fim_timeout", "preparacao", "jogar")
]

# Add transitions to the graph
for src, dst, label in transitions_moore:
    dot_moore.edge(src, dst, label)

# Define output paths
output_path = os.path.join(output_dir, "diagrama_moore_high")

# Save as DOT file
dot_moore.save(output_path + ".dot")

# Convert DOT to PDF
os.system(f"dot -Tpdf {output_path}.dot -o {output_path}.pdf")

print(f"Diagrama salvo em: {output_path}.pdf")
