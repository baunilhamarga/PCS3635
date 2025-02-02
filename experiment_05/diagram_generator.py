import graphviz
import os

# Criar diretório de saída se não existir
output_dir = "images"
os.makedirs(output_dir, exist_ok=True)

# Criando o diagrama de estados no formato de Máquina de Moore
dot_moore = graphviz.Digraph(format='png')

# Definição dos estados com ações dentro das elipses (Moore Machine)
states_moore = {
    "inicial": "Inicial\nzeraE=1\nzeraR=1",
    "preparacao": "Preparação\nzeraE=1\nzeraL=1",
    "nova_seq": "Nova Sequência\ncontaL=1",
    "espera": "Espera\ncontaT=1",
    "registra": "Registra\nregistraR=1",
    "comparacao": "Comparação",
    "proximo": "Próximo\ncontaE=1",
    "fim_acerto": "Fim (Acertou)\npronto=1\nacertou=1",
    "fim_erro": "Fim (Errou)\npronto=1, errou=1",
    "fim_timeout": "Fim (Timeout)\npronto=1\ndeu_timeout=1"
}

# Adicionando nós ao grafo
for state, label in states_moore.items():
    dot_moore.node(state, label, shape="ellipse")

# Adicionando transições
transitions_moore = [
    ("inicial", "preparacao", "jogar"),
    ("preparacao", "nova_seq", ""),
    ("nova_seq", "espera", ""),
    ("espera", "fim_timeout", "timeout"),
    ("espera", "registra", "jogada"),
    ("registra", "comparacao", ""),
    ("comparacao", "fim_acerto", "igualE e fimE e igualL"),
    ("comparacao", "nova_seq", "igualE e igualL"),
    ("comparacao", "proximo", "igualE"),
    ("comparacao", "fim_erro", "não igualE"),
    ("proximo", "espera", ""),
    ("fim_acerto", "preparacao", "jogar"),
    ("fim_erro", "preparacao", "jogar"),
    ("fim_timeout", "preparacao", "jogar")
]

# Adicionando arestas ao grafo
for src, dst, label in transitions_moore:
    dot_moore.edge(src, dst, label)

# Salvar o diagrama como PNG no diretório especificado
output_path = os.path.join(output_dir, "diagrama_moore")
dot_moore.render(output_path, format="png")

print(f"Diagrama salvo em: {output_path}.png")
