import graphviz
import os

# Create output directory if it doesn't exist
output_dir = "images"
os.makedirs(output_dir, exist_ok=True)

# Radius of the circles (fixed size for uniform appearance)
radius = 2.1

# Create state diagram with left-to-right layout
dot_moore = graphviz.Digraph(engine="dot", graph_attr={"rankdir": "LR", "splines": "true"})

# Define states using Verilog variable names and low-level signal descriptions
states_moore = {
    "inicial": "inicial\n-----------\nzeraE=1\nzeraR=1",
    "preparacao": "preparacao\n-----------\nzeraE=1\nzeraL=1",
    "nova_seq": "nova_seq\n-----------\nzeraE=1\ncontaL=1",
    "espera": "espera\n-----------\ncontaT=1",
    "registra": "registra\n-----------\nregistraR=1",
    "comparacao": "comparacao",
    "proximo": "proximo\n-----------\ncontaE=1",
    "fim_acerto": "fim_acerto\n-----------\npronto=1\nacertou=1",
    "fim_erro": "fim_erro\n-----------\npronto=1\nerrou=1",
    "fim_timeout": "fim_timeout\n-----------\npronto=1\ndeu_timeout=1"
}

# Add nodes with fixed-size circles
for state, label in states_moore.items():
    dot_moore.node(state, label, shape="circle", width=f"{radius}", height=f"{radius}", fixedsize="true")

# Define transitions using Verilog state names
transitions_moore = [
    ("inicial", "inicial", "não jogar"),
    ("inicial", "preparacao", "jogar"),
    ("preparacao", "espera", ""),
    ("nova_seq", "espera", ""),
    ("espera", "fim_timeout", "timeout"),
    ("espera", "registra", "jogada"),
    ("registra", "comparacao", ""),
    ("comparacao", "fim_acerto", "igualE e fimE"),
    ("comparacao", "nova_seq", "igualE e igualL"),
    ("comparacao", "proximo", "igualE"),
    ("comparacao", "fim_erro", "não igualE"),
    ("proximo", "espera", ""),
    ("fim_acerto", "fim_acerto", "não jogar"),
    ("fim_erro", "fim_erro", "não jogar"),
    ("fim_timeout", "fim_timeout", "não jogar"),
    ("fim_acerto", "preparacao", "jogar"),
    ("fim_erro", "preparacao", "jogar"),
    ("fim_timeout", "preparacao", "jogar")
]

# Add transitions to the graph
for src, dst, label in transitions_moore:
    dot_moore.edge(src, dst, label)

# Define output paths (keeping the same output filename)
output_path = os.path.join(output_dir, "diagrama_moore_low")

# Save as DOT file
dot_moore.save(output_path + ".dot")

# Convert DOT to PDF and PNG
os.system(f"dot -Tpdf {output_path}.dot -o {output_path}.pdf")
os.system(f"dot -Tpng {output_path}.dot -o {output_path}.png")

print(f"Diagrama salvo em: {output_path}.pdf")
