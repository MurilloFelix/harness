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

O dono tem de conseguir seguir os M sem abrir o chat, o plano ou outro arquivo. Escreva já no formato final: eles viram a checklist e, depois da aprovação, ficam congelados.

- **Texto simples:** frases curtas, uma ação por passo, sem ids de critério nem termos internos da fatia. Botão, menu e mensagem com o nome exato da tela.
- **Comando pronto para copiar:** inteiro, dizendo em qual terminal e pasta roda. Valor que muda (`<id>`) diz de onde sai. Nada de "suba o servidor", "configure X" ou "como no plano". **Pasta da fatia** é o worktree: o verificador escreve o caminho no topo da checklist.
- **Arquivo de configuração:** caminho completo e o trecho pronto para colar.
- **Esperado:** o que o dono vê ou ouve quando deu certo, concreto.
- **Se falhar:** só quando há algo específico a fazer (causa comum, o que conferir, qual log abrir). No resto, vale a regra geral do topo da checklist.

**Preparação:** o que o dono faz antes dos itens. Feature nova sempre tem: o que ela é e como chegar nela, o que instalar, o que buildar e rodar, o que ter em mãos para testar (arquivo, conta, aparelho), como saber que ficou pronto e como desfazer no fim. Só entra o que os itens usam e o dono ainda não tem: mudança pequena em algo que já roda tem uma linha de preparação, ou nenhuma.

Exemplo de feature nova (o `meuapp` é inventado; troque tudo):

````markdown
**Preparação**

O que é: o `meuapp` agora exporta relatórios em PDF por um servidor local. Você sobe o servidor, manda um arquivo e recebe o PDF.

1. Confira se o `meuapp` está instalado. O comando tem de mostrar 2.0 ou mais:

   ```
   meuapp --version
   ```

2. Copie um arquivo `.csv` pequeno qualquer para a pasta da fatia, com o nome `teste.csv`.
3. Abra um terminal na pasta da fatia, suba o servidor e deixe esse terminal aberto:

   ```
   meuapp serve --dados ./dados-teste
   ```

   Pronto quando aparecer `ouvindo na porta 7400`.
   Se falhar: `porta em uso` quer dizer que outro servidor ficou aberto. Feche-o e rode de novo.

Ao terminar: aperte `Ctrl+C` no terminal do servidor e apague a pasta `dados-teste`.

- **M1:** Exportar um relatório.
  1. Abra um segundo terminal na pasta da fatia e rode:

     ```
     meuapp enviar teste.csv --saida relatorio.pdf
     ```

  2. Abra o `relatorio.pdf`.

  Esperado: o terminal mostra `relatorio pronto`, e o PDF abre com uma tabela igual ao `teste.csv`.
- **M2:** Arquivo inválido é recusado.
  1. No mesmo terminal, rode `meuapp enviar README.md --saida ruim.pdf`.

  Esperado: o terminal mostra `formato inválido`, e o `ruim.pdf` não é criado.
````

Exemplo de mudança pequena, sem preparação:

```markdown
- **M1:** O botão mostra o nome novo.
  1. Abra o app e vá em Relatórios.

  Esperado: o botão diz `Exportar PDF`.
```

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
