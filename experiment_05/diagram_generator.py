import graphviz
import os

# Criar diretório para saída se não existir
output_dir = "images"
os.makedirs(output_dir, exist_ok=True)

# Criando o diagrama de estados (Máquina de Moore)
dot_moore = graphviz.Digraph(engine="dot", graph_attr={"rankdir": "LR", "splines": "true"})

# Definição dos estados com ações dentro das elipses (Máquina de Moore)
states_moore = {
    "inicial": "Inicial\nzeraE=1\nzeraR=1",
    "preparacao": "Preparação\nzeraE=1\nzeraL=1",
    "nova_seq": "Nova Seq\nzeraE=1",
    "espera": "Espera\ncontaT=1",
    "registra": "Registra\nregistraR=1",
    "comparacao": "Comparação",
    "proximo": "Próximo\ncontaE=1",
    "proxima_seq": "Próxima Seq\ncontaL=1",
    "fim_acerto": "Fim (Acertou)\npronto=1\nacertou=1",
    "fim_erro": "Fim (Errou)\npronto=1\nerrou=1",
    "fim_timeout": "Fim (Timeout)\npronto=1\ndeu_timeout=1"
}

# Adicionando estados ao grafo
for state, label in states_moore.items():
    dot_moore.node(state, label, shape="ellipse")

# Definição das transições
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

# Adicionando transições ao grafo
for src, dst, label in transitions_moore:
    dot_moore.edge(src, dst, label)

# Salvar como DOT
output_path = os.path.join(output_dir, "diagrama_moore")
dot_moore.save(output_path + ".dot")

# Converter DOT para PNG
os.system(f"dot -Tpng {output_path}.dot -o {output_path}.png")

print(f"Diagrama salvo em: {output_path}.png")
