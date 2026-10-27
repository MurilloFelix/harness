# Fluxo de trabalho

<!-- Arquivo do Harness (genérico). Não edite aqui: mude no Harness e atualize com `install.ps1 -Update`. O que é do projeto fica no AGENTS.md. -->

Como este projeto é construído com agentes de IA e com o dono. Vale para qualquer agente (Claude, Codex...) e para humanos. O que é específico do projeto (comandos, ambiente, regras de código) está no [`AGENTS.md`](../AGENTS.md), nas seções **Verificação**, **Formatação**, **Ambiente manual**, **Regras**, **Critérios obrigatórios** e **Parâmetros do fluxo**.

## Princípios

1. **Uma fatia vertical por vez.** Cada item do [roadmap](roadmap/README.md) é pequeno, entregável sozinho, testado e usado antes do próximo. Só uma fatia fica "em andamento".
2. **Abstração nasce no segundo uso, não no primeiro.** Nada de "já deixei preparado para o futuro".
3. **Toda mudança de comportamento vem com teste.** Separe decisão de efeito: a lógica é código puro com teste unitário, e a chamada ao mundo externo (SO, rede, UI, hardware) é a parte mais fina possível. Quanto mais lógica fica testável, mais critérios viram **A** em vez de **M**.
4. **Critérios antes do código.** Quem implementa não decide o que é "pronto" depois de ver o próprio código.
5. **Quem julga não é quem escreveu.** O crítico e o verificador rodam em contexto limpo e só sabem o que está escrito no repositório. Se algo só faz sentido com o contexto da conversa, o problema é do texto.
6. **Decisão de arquitetura → ADR primeiro**, código depois. Um ADR aceito não é contradito em silêncio: propõe-se um novo.
7. **Não invente API.** Na dúvida sobre como uma lib, ferramenta ou SO funciona, diga isso e verifique na documentação.
8. **Dependência nova precisa de justificativa** no commit/PR.
9. **"Não consegui checar" nunca vira "passou".**

## Papéis

| Papel | Quem | Escreve | Não pode |
|---|---|---|---|
| Dono | humano | aprova planos e emendas, executa os itens M, faz o merge | — |
| Sessão principal | agente que conversa com o dono | `plan.md` (junto com o dono), push, PR | aprovar o próprio plano, fazer merge |
| `plan-critic` | subagente, contexto limpo | `critique.md` | reescrever o plano, escrever código |
| `slice-implementer` | subagente (ou a sessão principal) | código, testes, commits | editar critérios, enfraquecer teste, push |
| `plan-verifier` | subagente, contexto limpo, **nunca quem implementou** | `verification.md` | alterar qualquer outro arquivo, inventar critério |

## Fluxo de uma fatia

Estrutura de pastas e o porquê em [`plans/README.md`](plans/README.md).

1. **Branch.** A partir da branch de integração **atualizada**, crie `slice/<id>-<slug>` no início do planejamento. Plano, crítica, código e verificação vão todos nela.
2. **Plano.** `docs/plans/<id>-<slug>/plan.md`, a partir de [`plans/_template.md`](plans/_template.md), escrito junto com o dono. Todo critério de aceite tem id e tipo:
   - **A (automático):** comando exato + resultado esperado; o verificador executa.
   - **I (inspeção):** onde olhar no código; o verificador lê e cita `arquivo:linha`.
   - **M (manual):** o que a IA não consegue validar (ver **Ambiente manual** no `AGENTS.md`). Vira checklist do dono.
3. **Crítica.** `plan-critic` escreve `critique.md`. Os bloqueantes são resolvidos no plano e a crítica roda de novo até o veredito ser `APROVADO` ou `APROVADO COM RESSALVAS`.
4. **Aprovação.** O dono muda o status para `Aprovado (AAAA-MM-DD)`. **A partir daqui os critérios estão congelados.** Mudança só como *Emenda* no fim do plano, aprovada pelo dono (e, se mudar critério, com nova crítica da emenda).
5. **Implementação.** Passos pequenos; ao fim de cada um: formatação, verificação padrão verde, um commit.
6. **Verificação.** `plan-verifier`, em contexto limpo, escreve `verification.md`. Se sair `REPROVADO`: corrige e roda um verificador **novo**.
7. **Checklist manual.** O dono executa os itens M e marca em `verification.md`.
8. **PR e merge.** Com a verificação `APROVADO`, a sessão principal dá push e abre o PR para a branch de integração. O dono confere a checklist, marca no PR e faz o merge.

**Quando pular plano e crítica:** correção de poucas linhas, docs, ajuste de lint/format. Nesses casos basta a verificação padrão. Na dúvida (adiciona funcionalidade pública, toca mais de um módulo, mexe em segurança), é fatia.

**Fora do Claude Code** (Codex etc.): abra uma sessão **nova** e passe como prompt o corpo do arquivo do agente (`.claude/agents/*.md`, sem o cabeçalho), junto com o caminho do plano. Sessão nova = sem contexto, que é o objetivo.

## Branches e pull requests

Nomes padrão abaixo; o `AGENTS.md` (**Parâmetros do fluxo**) pode trocá-los.

- **Integração (`dev`):** ninguém commita direto nela. Todo PR vai para ela.
- **Estável (`main`):** só recebe a integração ao **fechar uma fase do roadmap**, via PR aberto e mergeado pelo dono.
- **Fatia:** `slice/<id>-<slug>` (ex.: `slice/1.3-force-paste`). **Correção pequena fora de fatia:** `fix/<slug>`, mesmo fluxo de PR.
- O PR é aberto pela sessão principal, só depois de o `plan-verifier` dar `APROVADO`:
  `gh pr create --base <integração> --title "<tipo>(<escopo>): <fatia>" --body-file <arquivo>`
- A descrição do PR tem: link para `plan.md` e `verification.md`, resumo do que mudou e a **checklist manual** copiada do `verification.md`.
- **Merge só pelo dono**, por **squash**: o título do PR vira o commit na integração, então segue [Conventional Commits](https://www.conventionalcommits.org/) (`feat(input): 1.3 force paste`).
- Nenhum agente faz merge, rebase ou push forçado.
- Depois do merge a branch é apagada e a próxima fatia nasce da integração **atualizada**. Nunca comece uma fatia a partir da branch de outra ainda não mergeada: com squash, o conflito é garantido.

## Em qualquer passo

- **Revise o diff você mesmo.** A IA escreve; quem aprova é o dono. Desconfie de código que você não conseguiria explicar.
- **Commits** em Conventional Commits: `feat(<escopo>): ...`, `fix(...)`, `docs(plan): ...`, `test(...)`.

## Definição de pronto

- [ ] Verificação padrão passando (e o CI).
- [ ] Testes cobrindo o comportamento novo, incluindo o caminho de erro.
- [ ] Fatia com plano: `verification.md` com resultado `APROVADO` e checklist manual toda marcada.
- [ ] Itens extras da **Definição de pronto** do `AGENTS.md`, se houver.
- [ ] `docs/roadmap/` atualizado (item marcado no escopo e "Agora"/"A seguir" no `README.md`); `docs/architecture.md` ou ADR atualizado se o desenho mudou.
