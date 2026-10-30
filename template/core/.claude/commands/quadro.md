---
description: Mostra o quadro (colunas calculadas) sem mudar nada.
---

Calcule a coluna de cada card como `docs/board/README.md` descreve (integração para cards sem branch; worktree ou branch da fatia para os outros) e mostre o quadro. Pode rodar `git fetch` (e o `gh` para saber o estado dos PRs) para não mostrar o quadro velho. Fora isso, **não altere nada**: nem arquivos, nem branches, nem commits.

Formato:

1. **Com você**, primeiro: cada card com o motivo (plano, decisão, teste, merge, release) e o arquivo que o dono precisa abrir.
2. **Com o agente**, **Bloqueado** (com o card que bloqueia), **Start** (na ordem em que seriam puxados).
3. Uma linha com a contagem de **Backlog**, **Ideias** e **Feito**.
