# Fluxo de trabalho

<!-- Arquivo do Harness (genérico). Não edite aqui: mude no Harness e atualize com `install.ps1 -Update`. O que é do projeto fica no AGENTS.md. -->

Como este projeto é construído com agentes de IA e com o dono. Vale para qualquer agente (Claude, Codex...) e para humanos. O que é específico do projeto (comandos, ambiente, regras de código, limites do quadro) está no [`AGENTS.md`](../AGENTS.md), nas seções **Verificação**, **Formatação**, **Ambiente manual**, **Regras**, **Critérios obrigatórios** e **Parâmetros do fluxo**.

Em uma frase: o dono monta épicos e cards e libera os que quer; o tech lead puxa o que dá para fazer, leva cada card pelo fluxo (plano → crítica → implementação → verificação) e para em cada ponto que é do dono; quando o dono libera, o tech lead segue. A ideia é que, quando o dono quiser trabalhar, já exista algo esperando só por ele.

## Princípios

1. **Um quadro, não uma fila.** O trabalho são [cards](board/README.md) agrupados em épicos. O que bloqueia de verdade é o `depende` de cada card; a ordem dentro de um épico orienta o dono ao liberar e priorizar. Cada card de fatia é **vertical**: pequeno, entregável sozinho, testado e usado.
2. **Limite de trabalho em andamento.** Poucas trilhas implementando e poucos planos abertos ao mesmo tempo (**Parâmetros do fluxo**). Paralelizar ao máximo não é o objetivo; ter sempre algo pronto para o dono é.
3. **Abstração nasce no segundo uso, não no primeiro.** Nada de "já deixei preparado para o futuro".
4. **Toda mudança de comportamento vem com teste.** Separe decisão de efeito: a lógica é código puro com teste unitário, e a chamada ao mundo externo (SO, rede, UI, hardware) é a parte mais fina possível. Quanto mais lógica fica testável, mais critérios viram **A** em vez de **M**.
5. **Critérios antes do código.** Quem implementa não decide o que é "pronto" depois de ver o próprio código.
6. **Quem julga não é quem escreveu.** O crítico e o verificador rodam em contexto limpo e só sabem o que está escrito no repositório. Se algo só faz sentido com o contexto da conversa, o problema é do texto.
7. **Decisão de arquitetura → ADR primeiro**, código depois. Um ADR aceito não é contradito em silêncio: propõe-se um novo.
8. **Não invente API.** Na dúvida sobre como uma lib, ferramenta ou SO funciona, diga isso e verifique na documentação.
9. **Dependência nova precisa de justificativa** no commit/PR.
10. **"Não consegui checar" nunca vira "passou".**

## Papéis

| Papel | Quem | Escreve | Não pode |
|---|---|---|---|
| Dono | humano | cards e épicos (com o tech lead), a `coluna` dos cards, aprovação do plano e das emendas, respostas em `pendencias.md`, checklist manual, merge | — |
| Tech lead | a sessão principal, que conversa com o dono | cards e épicos quando o dono pede, card em Ideias para trabalho descoberto; `plan.md` (inclusive o `Status` depois da aprovação e as *Emendas*); `pendencias.md`; os commits das saídas dos subagentes e das edições do dono; push; PR | aprovar plano ou emenda, mover card para Start, fazer merge, rebase ou push forçado |
| `plan-critic` | subagente, contexto limpo | `critique-rN.md` (um por rodada) | reescrever o plano, escrever código, mexer em críticas anteriores |
| `slice-implementer` | subagente | código, testes, commits de código | editar critérios, plano, quadro ou `pendencias.md`, enfraquecer teste, push |
| `plan-verifier` | subagente, contexto limpo, **nunca quem implementou** | `verification-rN.md` (um por rodada) | alterar qualquer outro arquivo, inventar critério |

O tech lead coordena e escreve planos; quem escreve código é o `slice-implementer`. Assim o contexto do tech lead fica limpo para acompanhar o quadro inteiro.

## Quadro

Formato dos cards e épicos, e como cada coluna é calculada: [`board/README.md`](board/README.md). Em resumo:

```
Ideias ─► Backlog ─► Start ─► Com o agente ⇄ Com você ─► Feito
 (dono)    (dono)   (dono)       (calculado a partir da branch)
```

O dono só move cards entre Ideias, Backlog e Start (e para Descartado). **Mover para Start é a autorização** para o tech lead puxar. Daí em diante a coluna é calculada dos arquivos da fatia, e o card anda sozinho entre *Com o agente* e *Com você*.

### O que o dono faz

Cada parada do fluxo é um arquivo que o dono edita **localmente**: no checkout principal (o quadro) ou no worktree da fatia (`<pasta dos worktrees>/<id>-<slug>/`). Não precisa commitar: o tech lead commita e dá push no ciclo seguinte. Não edite esses arquivos pela web do GitHub: a branch remota divergiria da local, e o tech lead não pode fazer rebase nem push forçado.

| Quando | O dono... | Onde |
|---|---|---|
| **liberar** | muda a `coluna` do card para `start` (ou `backlog`, `ideias`, `descartado`) | o card, no checkout principal (integração) |
| Com você: **plano** | lê *Decisões para o dono* e muda o status para `Aprovado (AAAA-MM-DD)`; ou pede mudança num item em *Para o agente* | `plan.md`, `pendencias.md` |
| Com você: **decisão** | responde abaixo do item e marca `[x]` | `pendencias.md`, *Para o dono* |
| Com você: **emenda** | aprova a emenda escrevendo "aprovado por <dono> (AAAA-MM-DD)" nela; ou recusa num item em *Para o agente* | `plan.md`, *Emendas* |
| Com você: **teste** | executa os itens M e marca a checklist; se algo falhar, abre um item em *Para o agente* | última `verification-rN.md`, `pendencias.md` |
| Com você: **merge** | revisa o diff e faz o merge (squash); ou pede mudança num item em *Para o agente* (comentário no PR não é lido) | GitHub, `pendencias.md` |
| Com você: **release** | confere o PR da integração para a estável e faz o merge (merge commit) | GitHub |
| **descartar** um card com branch | pede num item em *Para o agente*; o tech lead fecha o PR, apaga a branch e marca o card | `pendencias.md` |

### pendencias.md

Arquivo opcional na pasta da fatia (`docs/plans/<id>-<slug>/`, também para card `correcao`), o canal entre o tech lead e o dono fora da conversa:

```markdown
# Pendências: <id> <título>

## Para o dono
- [ ] <pergunta ou escalação, com o contexto e as opções>
  Resposta: <o dono escreve aqui e marca [x]>

## Para o agente
- [ ] <pedido do dono: mudança no plano, problema achado no teste>
  Resolvido em: <o tech lead escreve aqui e marca [x]: commit, rodada de crítica ou de verificação>
```

Item aberto em *Para o dono* deixa o card em **Com você: decisão**; em *Para o agente*, em **Com o agente**. Quem marca `[x]` é quem resolveu: o dono em *Para o dono*, o tech lead em *Para o agente*, e só quando a resolução terminou (por exemplo, a verificação nova depois de uma correção). Itens fechados ficam como histórico. Uma resposta que muda o desenho ou um critério entra no plano: antes da aprovação, como revisão (com nova crítica); depois, como *Emenda*.

## Ciclo do tech lead

O tech lead trabalha em ciclos. Um ciclo começa quando o dono pede (`/ciclo`, "segue", "liberei a 31") e **recomeça sozinho** sempre que um passo termina (um subagente voltou, um commit foi feito). Ele só para quando nada mais pode andar sem o dono. Não pergunta "quer que eu continue?": se há algo liberado para fazer, faz.

### Regras de git do tech lead

- **Commita tudo o que não é código, logo que aparece:** o plano que escreveu, a saída de cada subagente assim que ele volta (`docs(plan): <id> crítica rN`, `docs(plan): <id> verificação rN`) e as edições do dono (`docs(plan): <id> <o que o dono fez>`, `chore(quadro): ...`). Antes de chamar um subagente, o worktree está limpo.
- **Todo commit do tech lead é seguido de push**, na branch da fatia ou na integração.
- **Nunca mexe num worktree enquanto um subagente roda nele.** E, ao commitar uma edição do dono, commita só os arquivos do dono.
- **Só avança por fast-forward:** atualiza a integração local com `git merge --ff-only` da remota, e as branches com PR com `git pull --ff-only`. Se falhar, para e relata: nunca rebase nem push forçado.
- **Apagar:** `git worktree remove` sem `--force` (worktree sujo → relata e deixa); a branch mergeada por squash é apagada com `git branch -D` **só depois** de o `gh` confirmar o merge do PR dela.

### Cada volta

1. **Sincronizar.** `git fetch`; atualizar a integração local e as branches com PR (fast-forward). Calcular a coluna de cada card ([`board/README.md`](board/README.md#colunas)).
2. **Recolher o que o dono fez.** No checkout principal, mudanças do dono em `docs/board/` → `chore(quadro): ...` e push. Em cada worktree sem subagente rodando, as edições do dono (status do plano, emenda aprovada, checklist, `pendencias.md`) → commit e push.
3. **Fechar o que terminou.**
   1. PR de fatia ou correção mergeado: remover o worktree e apagar a branch (local e remota). PR de release mergeado: `coluna: feito` no card do release, na integração.
   2. PR fechado sem merge: item em *Para o dono* perguntando se o card é descartado ou se o PR volta.
   3. **Depois de qualquer merge na integração**, trazer a integração para cada branch com trilha ocupada (merge, nunca rebase), resolver os arquivos comuns, rodar a **Verificação**, commit e push. Se a fatia já tinha verificação `APROVADO` e o merge tocou algo que um critério cita, roda um `plan-verifier` novo, e o resumo avisa o dono que a checklist dela recomeça.
4. **Avançar o que já começou**, do mais perto do fim para o mais longe:
   1. **Item aberto em *Para o agente*:** antes da aprovação do plano, revisar o plano e rodar nova crítica; depois, escrever uma *Emenda* (o dono aprova) ou mandar o `slice-implementer` corrigir e depois rodar um `plan-verifier` novo. Marcar `[x]` com *Resolvido em* só quando terminar. Pedido de descarte: fechar o PR, remover worktree e branch, e `coluna: descartado` no card, na integração.
   2. **Verificação `REPROVADO`:** `slice-implementer` corrige o que ela aponta → `plan-verifier` novo. **`INCOMPLETO`:** não há o que o implementador corrigir: item em *Para o dono* com o motivo (ambiente, critério ambíguo) e as opções. Passou do limite de rodadas de verificação (**Parâmetros do fluxo**) sem `APROVADO`: item em *Para o dono*.
   3. **`Status: Implementado` sem verificação do último commit:** `plan-verifier`.
   4. **Verificação `APROVADO` sem PR:** `coluna: feito` no card (na branch), commit, push e PR. Com a checklist toda marcada e sem mudanças desde a verificação, o card fica em Com você: merge.
   5. **`Status: Em implementação`** (o implementador parou: a sessão caiu, ou ele escalou e o dono já respondeu): `slice-implementer` retoma de onde parou. Não precisa de trilha nova: a fatia já ocupa uma.
   6. **`Status: Aprovado` com trilha livre**, e sem conflito com as fatias que estão implementando (campo **Trilha** dos planos): trazer a integração para a branch, `Status: Em implementação (aprovado em AAAA-MM-DD)`, commit, push, `slice-implementer`. Ao voltar `CONCLUÍDA` → `Status: Implementado (aprovado em AAAA-MM-DD)`; `ESCALADO` → item em *Para o dono* com o relatório e as opções (o status fica `Em implementação`).
   7. **Card `correcao` com branch:** `slice-implementer` em modo correção → o tech lead roda a **Verificação** → `coluna: feito`, commit, push, PR.
   8. **Plano em crítica:** próxima rodada do `plan-critic`, passando a ele a lista dos outros cards com branch e o que cada um toca (do *Desenho* de cada plano). Passou do limite de rodadas de crítica sem aprovar, contando desde a última resposta do dono: item em *Para o dono* explicando o impasse.
5. **Puxar do Start.** Na ordem de [`board/README.md`](board/README.md#card) (prioridade, depois `id`), pulando os bloqueados:
   - **fatia**, enquanto houver menos **planos abertos** (cards de fatia com branch e plano ainda não aprovado: planejando, em crítica, esperando o dono) do que o limite: branch a partir da integração atualizada, worktree, `plan.md` a partir do card (commit e push), e crítica até aprovar.
   - **correcao**, se houver trilha livre (não conta nos planos abertos): branch `fix/<id>-<slug>`, worktree, e o passo 4.7. Se a correção não couber em *Quando pular plano e crítica*, item em *Para o dono* propondo virar fatia.
   - **release**, se não houver um PR de release aberto: o PR da integração para a estável.
6. **Relatar e parar.** Um resumo curto: o que está **com você** (com o motivo e o caminho do arquivo), o que está com o agente, o que está bloqueado e por quê, o próximo do Start e os cards que o tech lead criou em Ideias.

**Paralelo:** passos de cards diferentes podem rodar ao mesmo tempo (o crítico de um enquanto o implementador de outro trabalha), sempre dentro dos limites. Cada subagente recebe o caminho do worktree do card e trabalha só nele.

**Trabalho novo descoberto no caminho** vira card em Ideias, criado na integração (regra 3 do quadro) e citado no resumo. O tech lead não o faz por conta própria nem o move para Start.

**Card sem branch e sem decisão do dono** (Ideias, Backlog) não é tocado pelo tech lead, a não ser que o dono peça.

## Fluxo de uma fatia

Estrutura de pastas e o porquê em [`plans/README.md`](plans/README.md).

1. **Branch e worktree.** A partir da integração **atualizada**, crie `slice/<id>-<slug>` (o `id` e o `slug` do card) num worktree próprio, na pasta dos worktrees (**Parâmetros do fluxo**). Spike, plano, crítica, código e verificação vão todos nela.
2. **Spike (opcional).** Só quando o desenho depende de algo que só se descobre rodando. Ver [Spike](#spike).
3. **Plano.** `docs/plans/<id>-<slug>/plan.md`, a partir de [`plans/_template.md`](plans/_template.md) e do card. O tech lead escreve; o que só o dono pode decidir vai em *Decisões para o dono* (ou, se travar o desenho, em `pendencias.md` antes de seguir). Todo critério de aceite tem id e tipo:
   - **A (automático):** comando exato + resultado esperado; o verificador executa.
   - **I (inspeção):** onde olhar no código; o verificador lê e cita `arquivo:linha`.
   - **M (manual):** o que a IA não consegue validar (ver **Ambiente manual** no `AGENTS.md`). Vira checklist do dono.
4. **Crítica, em rodadas.** `plan-critic` escreve `critique-r1.md`. Os bloqueantes são resolvidos no plano, que sobe de revisão (`Em crítica (revisão 2)`), e a crítica roda de novo num arquivo novo (`critique-r2.md`...) até o veredito ser `APROVADO` ou `APROVADO COM RESSALVAS`, ou até o limite de rodadas, quando o impasse vai para o dono. Nenhuma crítica é sobrescrita. Perguntas do crítico são respondidas no plano, em *Respostas às perguntas das críticas*.
5. **Aprovação.** Com você: plano. O dono lê *Decisões para o dono* e muda o status para `Aprovado (AAAA-MM-DD)`. **A partir daqui os critérios e o card estão congelados.** Mudança só como *Emenda* no fim do plano, aprovada pelo dono (e, se mudar critério, com a crítica da emenda em `critique-eX-rN.md`). No card, depois da aprovação, só a `coluna` muda.
6. **Implementação.** Quando houver trilha livre. O status passa a `Em implementação` e, ao terminar, `Implementado`. Passos pequenos; ao fim de cada um: formatação, verificação padrão verde, um commit.
7. **Verificação, em rodadas.** `plan-verifier`, em contexto limpo, escreve `verification-r1.md`. Se sair `REPROVADO`: corrige e roda um verificador **novo**, que escreve `verification-r2.md` sem ler as anteriores. Nenhuma verificação é sobrescrita.
8. **PR.** Com a verificação `APROVADO`, o tech lead marca o card como feito (na branch), dá push e abre o PR para a integração.
9. **Teste e merge.** Com você: teste. O dono executa os itens M e marca a checklist na última verificação (a `APROVADO`); o tech lead commita e dá push. Com você: merge. O dono revisa e faz o merge. Se o teste achar um problema, ele vira item em *Para o agente*: o implementador corrige, um verificador novo escreve uma nova verificação, e a checklist recomeça nela.

**Quando pular plano e crítica:** correção de poucas linhas, docs, ajuste de lint/format. Nesses casos o card é `tipo: correcao` (branch `fix/<id>-<slug>`): o implementador trabalha a partir do card, e basta a verificação padrão. Na dúvida (adiciona funcionalidade pública, toca mais de um módulo, mexe em segurança), é fatia.

**Fora do Claude Code** (Codex etc.): o quadro e o fluxo são só arquivos e git, então qualquer agente faz o papel de tech lead seguindo esta página. Para crítico e verificador, abra uma sessão **nova** e passe como prompt o corpo do arquivo do agente (`.claude/agents/*.md`, sem o cabeçalho), junto com o caminho do plano e do worktree. Sessão nova = sem contexto, que é o objetivo.

## Spike

Quando o desenho depende de um comportamento que a documentação não responde (como uma lib, o SO, um hardware ou um serviço externo se comporta de verdade), descubra rodando antes de planejar em cima de um palpite.

- **Pergunta primeiro.** Escreva as perguntas que o spike responde (no ADR ou no rascunho do plano). Sem pergunta, não é spike, é implementação adiantada.
- **Programa descartável** em `docs/plans/<id>-<slug>/spike/`, fora do build e da **Verificação** do projeto (se a ferramenta de build pegaria a pasta sozinha, exclua-a). Logs e artefatos de build ficam fora do git.
- **Resultado em `spike.md`**, na pasta da fatia: data, ambiente, cada pergunta com a resposta e a evidência (trechos de log, números), e o que isso muda no plano ou no ADR.
- **Spike não vira código da fatia.** O que se aproveitar é reescrito pelos passos do plano, com teste. O plano e o ADR citam o `spike.md`; o crítico o lê como evidência.
- Spike que precisa rodar no **Ambiente manual** é do dono: vira item em *Para o dono*, com o programa pronto e o que observar.

## Trilhas em paralelo

Uma **trilha** é um card **implementando**: uma fatia com `Status: Em implementação` ou `Implementado`, ou uma correção com branch, até o merge (inclusive esperando teste e merge). Planejar não ocupa trilha, mas tem o seu próprio limite (**planos abertos**). Como a trilha só é liberada no merge, os testes esperando o dono nunca passam do número de trilhas.

- **Só cards independentes ocupam trilhas ao mesmo tempo.** Dois cards implementam juntos quando não mexem nos mesmos módulos nem nas mesmas pastas de código. Se uma fatia aprovada conflita com uma que está implementando, ela espera a outra ser mergeada.
- **Todas saem da integração**, nunca uma da outra, e cada uma no seu worktree.
- **O plano declara a trilha** (campo **Trilha**): com quais cards pode implementar junto, com quais conflita, quais arquivos tocam em comum (índices, docs compartilhados, arquivos gerados; o `AGENTS.md` lista os de sempre) e o que muda se outro chegar antes à integração. O crítico cobra isso, com a lista de cards abertos que o tech lead passa a ele.
- **Quem chega depois se atualiza** (passo 3.3 do ciclo): a branch traz a integração por **merge** (nunca rebase), resolve os arquivos comuns, regenera o que for gerado e roda a **Verificação** de novo. Se o merge mexeu em algo que um critério cita, roda uma nova rodada de verificação.

## Branches e pull requests

Nomes padrão abaixo; o `AGENTS.md` (**Parâmetros do fluxo**) pode trocá-los.

- **Integração (`dev`):** ninguém commita direto nela, **exceto o quadro** (`docs/board/`, `chore(quadro): ...`, pelo dono ou pelo tech lead). Todo PR vai para ela. O checkout principal do repositório fica nela; as fatias ficam nos worktrees.
- **Estável (`main`):** só recebe a integração por um card `release`, que o dono põe em Start quando quiser (o tech lead pode criar um em Ideias quando um épico atinge o *pronto quando* ou muitos cards se acumulam). O tech lead abre o PR listando os cards feitos desde o último release e atualiza a lista a cada ciclo enquanto ele estiver aberto:
  `gh pr create --base <estável> --head <integração> --title "release: [<id>] <título>" --body-file <arquivo>`
  O dono faz o merge **com merge commit** (squash aqui faria a estável divergir da integração).
- **Fatia:** `slice/<id>-<slug>` (ex.: `slice/31-overlay-remap`). **Correção:** `fix/<id>-<slug>`, mesmo fluxo de PR.
- O PR de fatia é aberto pelo tech lead, só depois de o `plan-verifier` dar `APROVADO`; o de correção, depois de a **Verificação** passar:
  `gh pr create --base <integração> --title "<tipo>(<escopo>): [<id>] <título>" --body-file <arquivo>`
  O id vai entre colchetes, não com `#`: no GitHub, `#31` vira link para o issue ou PR 31, que não é o card.
- A descrição do PR tem: link para o card, o `plan.md` e a última verificação, e o resumo do que mudou. A **checklist manual** fica só na verificação, onde o dono marca.
- **Merge de fatia e correção só pelo dono**, por **squash**: o título do PR vira o commit na integração, então segue [Conventional Commits](https://www.conventionalcommits.org/) (`feat(input): [31] force paste`).
- Nenhum agente faz merge de PR, rebase ou push forçado. A única exceção é o tech lead trazer a integração para a branch de um card por merge (passo 3.3 do ciclo).
- Depois do merge a branch e o worktree são apagados, e o próximo card nasce da integração **atualizada**. Nunca comece um card a partir da branch de outro ainda não mergeado: com squash, o conflito é garantido. É por isso que card com dependência aberta fica **Bloqueado**, em vez de começar.

## Em qualquer passo

- **Revise o diff você mesmo.** A IA escreve; quem aprova é o dono. Desconfie de código que você não conseguiria explicar.
- **Commits** em Conventional Commits: `feat(<escopo>): ...`, `fix(...)`, `docs(plan): ...`, `test(...)`, `chore(quadro): ...`.

## Definição de pronto

- [ ] Verificação padrão passando (e o CI).
- [ ] Testes cobrindo o comportamento novo, incluindo o caminho de erro.
- [ ] Fatia com plano: última verificação (`verification-rN.md`) com resultado `APROVADO` e checklist manual toda marcada.
- [ ] Itens extras da **Definição de pronto** do `AGENTS.md`, se houver.
- [ ] Card com `coluna: feito` na branch; `docs/architecture.md` ou ADR atualizado se o desenho mudou.
