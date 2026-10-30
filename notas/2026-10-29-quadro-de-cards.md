# Quadro de cards: decisões e próximos passos

Resumo da conversa (claude.ai, outubro de 2026) que trocou o roadmap em fases por um quadro de cards com um tech lead. O resultado está em `template/core/docs/workflow.md` e `template/core/docs/board/README.md`; esta nota guarda o **porquê** e o que ficou **para depois**.

## O problema

O roadmap em fases dava a sensação de "fechar fase e não poder voltar". O trabalho real já não era sequencial: dependências cruzavam fases (a 2.3 dependia do `watch` da 3.2), fases corriam em paralelo e os ids mudavam de sentido quando a ordem mudava (a nota de "numeração antiga" no fim do `desktop.md` do Deckify).

## O que o dono quer

- Montar épicos e cards junto com o agente, mover para **Start** os que libera, e o agente puxar sozinho o que dá para fazer.
- O agente para em cada ponto que é do dono (aprovar plano, decidir, testar os M, merge) e, quando o dono libera, segue sem precisar de pedido.
- **Não** é paralelizar ao máximo. É: quando o dono quiser trabalhar, já ter algo esperando só por ele. Se ele não quiser revisar agora, tudo bem.
- Os passos manuais continuam todos.

## Decisões

| Decisão | Por quê |
|---|---|
| Um `.md` por card, `id` numérico que não diz ordem | Várias branches sem conflito no quadro; o id não quebra quando a ordem muda. |
| Card pertence a um épico só; ligações por `tags` e `depende` | O épico é quem diz "pronto quando"; dois donos deixam isso ambíguo. |
| `depende` só para bloqueio de verdade (precisa estar mergeado) | Grafo detalhado ninguém mantém; com squash, começar em cima de branch não mergeada dá conflito garantido. |
| A integração (`dev`) é a verdade dos cards sem branch; a branch é a verdade do card dela | Ideia do dono. O status de uma fatia vem dos arquivos do fluxo (plano, críticas, verificações, `pendencias.md`), não de um campo duplicado. |
| O dono só move Ideias / Backlog / Start / Descartado; o resto é calculado | O card anda sozinho entre "Com o agente" e "Com você". |
| Commit direto na `dev` só para `docs/board/` (`chore(quadro)`) | O dono trabalha sozinho; o resto continua por PR. |
| Tech lead = a sessão principal; não escreve código | Coordena com o contexto limpo; código é do `slice-implementer`. |
| Limites: 2 trilhas, 2 planos abertos; testes esperando ≤ trilhas | O dono disse que 2 de cada já é muito para dar atenção. |
| Trilha conta da implementação até o merge; planejar não ocupa trilha | Permite planejar o próximo enquanto o dono testa o atual. |
| `pendencias.md` como canal fora da conversa | O tech lead e uma sessão nova leem o estado do repositório, não do chat. |
| Merge na `main` por card `release` (merge commit, não squash) | Fechar fase deixou de existir; como toda fatia é vertical, a `dev` nunca tem nada pela metade. |
| Quadro no repositório, não no GitHub Projects | O GitHub Projects foi considerado (tem interface, celular, notificação), mas exige sincronizar nos dois sentidos e é mais frágil para o agente. Fica como possível visualização depois, só lendo. |
| Deckify: ids começam em 100 | Para "31" não confundir com a fatia "3.1" do roadmap antigo. |

## Para depois

1. **Front do quadro** (ideia do dono): página local separada que lê o repositório (a `dev` e as branches ou worktrees), mostra as colunas calculadas e só escreve nos campos manuais, na `dev`, num worktree próprio. Fica fora do `core/` (é ferramenta, como o `install.ps1`). Node com `git` + React, tema escuro. Fazer depois que o formato do card se firmar no teste.
2. **Mod do Claude Code** para o que o front não faz:
   - um timer que olha o repositório e começa o `/ciclo` sozinho quando o dono libera algo;
   - notificação quando um card vai para "Com você";
   - barreiras de verdade contra `gh pr merge`, push forçado e edição de critério aprovado.

   A API de mods é nova e muda entre versões. O `workflow.md` continua sendo o contrato, e o mod é só acelerador.
3. **Seguir com o dono longe** (computador ligado, sem sessão aberta): tarefa agendada. Só depois de o ciclo manual estar redondo.

## Estado em 2026-10-29

- Harness: as mudanças estão no working tree da `main`, sem commit. Os arquivos de `.claude/` e `.github/` estão em `_pendente/` (o acesso remoto não escreve nessas pastas): rode `pwsh ./_pendente/aplicar.ps1`, revise o diff e commite.
- Deckify, branch `feat/quadro`: o Harness foi instalado (antes o fluxo estava todo no `AGENTS.md`), com 6 épicos e os cards #100 a #117. As fases 4 a 6 viraram cards em Ideias para o dono reescrever, e o #101 está em Backlog. Mesmo passo do `_pendente/`.
- Primeiro teste: o dono reescreve os cards de captura ou de soundboard, põe um ou dois em `start` e roda `/ciclo`.
- Atenção: cada worktree tem o próprio `target/` do Cargo, então o primeiro build de cada card é lento.
