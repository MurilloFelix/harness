# <id>: <título>

- **Status:** Rascunho | Em crítica (revisão N; [crítica N-1](critique-rN-1.md): <veredito>) | Aprovado (AAAA-MM-DD) | Em implementação (aprovado em AAAA-MM-DD) | Implementado (aprovado em AAAA-MM-DD)
- **Data:** AAAA-MM-DD
- **Card:** [#<id> <título>](../../board/cards/<id>-<slug>.md)
- **Épico:** [<título>](../../board/epics/<slug>.md) | _nenhum_
- **ADRs relacionados:** <links>
- **Spike:** [`spike.md`](spike.md) | _não houve_
- **Trilha:** independente de: <cards que podem implementar junto, ou "qualquer um">. Conflita com: <cards que mexem nos mesmos módulos; espera o merge deles>. Arquivos comuns: <lista>. Se outro chegar antes à integração: <o que muda aqui>.

## Objetivo

O que muda para o dono quando isto estiver pronto, do ponto de vista de uso, em 1 a 3 frases. Parte do *O que entrega* do card; se divergir dele, diga por quê em *Decisões para o dono*.

## Fora de escopo

O que **não** entra nesta fatia, mesmo que pareça natural fazer junto. Inclui o *Fora* do card.

## Desenho

- Módulos/arquivos novos ou alterados.
- Tipos, funções e interfaces públicas (nomes, entrada, saída).
- Fluxo principal e fluxos de erro.
- Dependências novas, com justificativa.
- Decisão nova de arquitetura → ADR antes (link aqui).
- Comportamento externo de que o desenho depende → documentação ou `spike.md` (link aqui), nunca suposição.

Pense em testabilidade: o que puder ficar fora da camada de plataforma/UI, em código puro testável, vira critério **A** em vez de **M**.

## Passos

1. <passo> (cada passo termina com a verificação padrão verde e um commit)
2. …

## Critérios de aceite

Regras para todo critério:

- Tem id (`A1`, `I1`, `M1`) e é **observável**. Se alguém sem contexto perguntaria "o que isso quer dizer?", reescreva.
- Cobre também o caminho de erro, não só o caminho feliz.
- Inclui os **Critérios obrigatórios** do `AGENTS.md` que se aplicam a esta fatia.
- Depois da aprovação, **não se edita**. Mudança só em *Emendas*.

### A: Automáticos (o verificador executa)

- **A1:** <critério>.
  Comando: `<comando exato>`
  Esperado: <saída / código de saída / teste específico passando>

### I: Inspeção (o verificador lê o código)

- **I1:** <critério>.
  Onde: `<arquivo ou padrão de busca>`

### M: Manuais (o dono executa no ambiente manual, vira checklist)

Antes: <preparação comum a todos os M: build, config, o que fechar/abrir>.

- **M1:** <critério>.
  Passos: 1. … 2. …
  Esperado: <o que o dono deve ver>

## Riscos

- <o que pode dar errado e como o plano lida com isso>

## Respostas às perguntas das críticas

Uma linha por pergunta do crítico, agrupadas por rodada. Resposta que muda o desenho entra também no *Desenho* e nos critérios; aqui fica só o resumo e onde está.

- **Crítica 1, <pergunta resumida>:** <resposta> (<seção / id>).

## Decisões para o dono (na aprovação)

Escolhas que o plano faz e que o dono aprova junto com ele: alternativas descartadas, comportamentos discutíveis, divergências do card, cards criados em Ideias por causa desta fatia. Cada uma diz o que sai do plano se o dono não quiser.

- **<decisão>:** <por quê>. Se não quiser: <critérios / seções que mudam>.

## Emendas

Mudanças nos critérios depois da aprovação, escritas pelo tech lead. Cada uma com id (`E1`), data, motivo e crítica da emenda (`critique-e1-rN.md`), se mudar critério. Enquanto não tiver "aprovado por <dono> (AAAA-MM-DD)", escrito pelo dono, o card fica em Com você: emenda e ninguém implementa a emenda.

- _nenhuma_
