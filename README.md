# Validador OCOREN

Aplicação React + TypeScript para conferir e corrigir arquivos de ocorrências de entrega, com layouts 3.1 e 5.0. Os arquivos são lidos e processados exclusivamente na memória do navegador. Não há backend, upload, telemetria, fontes externas ou armazenamento persistente dos dados.

## Executar

Requer Node.js 22.14 ou superior e npm. Neste computador foi preparado um runtime portátil em `.tools` (ignorado pelo Git), utilizado automaticamente por `iniciar.cmd`:

```powershell
cd D:\Diretorio\TypeScript
.\iniciar.cmd
```

Com Node.js instalado no PATH:

```powershell
cd D:\Diretorio\TypeScript
npm ci
npm run dev
```

```powershell
npm test
npm run build
npm run preview
npm run test:e2e
```

## Uso

1. Abra ou arraste um arquivo. A versão é detectada pelos registros; confirme o layout no seletor.
2. Selecione uma linha na lista ou clique em um erro no relatório. O mapa marca as posições e mostra detalhes ao passar o mouse.
3. Edite um campo e clique em Salvar. Números recebem zeros à esquerda; texto recebe espaços à direita. Valores maiores que o campo são rejeitados, sem truncamento silencioso. Quantidades são informadas em dígitos com decimais implícitos (00000125 = 1,25).
4. Use a edição de linha completa para corrigir identificadores ou comprimentos. Ela preserva exatamente o texto digitado e não completa automaticamente o registro.
5. Exporte a cópia com o sufixo `-corrigido`. O original no disco nunca é modificado. A exportação é permitida com erros pendentes, informados na mensagem de resultado.

Desfazer mantém as últimas 30 alterações; Restaurar original recupera os dados importados. Importar outro arquivo ou carregar um exemplo substitui a sessão atual. A codificação de saída pode ser escolhida. UTF-8 válido é detectado primeiro; outros arquivos são interpretados como Windows-1252. Arquivos apenas ASCII são equivalentes nas duas codificações. UTF-16 não é aceito. As quebras CRLF, LF e CR e a presença/ausência de quebra final são preservadas. BOM UTF-8 é preservado se a codificação não for alterada. Caracteres sem representação em Windows-1252 bloqueiam a exportação nessa codificação.

## Regras e fontes

Implementação baseada nos manuais fornecidos: `OCOREN31.RTF` (PROCEDA, 15/05/2000) e `OCOREN-50.pdf` (TIVIT, 31/07/2008). Os manuais não são distribuídos com a aplicação.

- 3.1: 120 posições; 000 → 340 → 341 → 342 → 343 opcional. Até 200 documentos e 5.000 ocorrências por transportadora.
- 5.0: 250 posições; 000 → 540 → 541 → 542 → complementos opcionais 543, 544 e 545 → 549. Até 200 documentos, 9.999 ocorrências por transportadora e 9.999 registros 544 por ocorrência. 543 e 545 ocorrem no máximo uma vez por 542.
- Campos obrigatórios, tipos, alinhamento, maiúsculas na versão 3.1, datas reais, horários, tabela de códigos de ocorrência, observações, tipo de entrega, fillers, sequência e contagem 549.
- Campos numéricos condicionais ausentes devem ser preenchidos com zeros; alfanuméricos, com espaços. Zero é válido para o código 000 em 5.0, quantidades e meia-noite. O manual permite ponto ou asterisco na última posição do registro; essa exceção é aceita.
- Código 038 não aparece na tabela 5.0 e é rejeitado. A tabela inclui 000–105, exceto 038, e 201–213.
- CNPJ: formato numérico e preenchimento, sem validação de dígitos ou cadastro. Identificações de documento/intercâmbio sugeridas nos manuais não são exigidas como constantes.
- Datas DDMMAA são interpretadas como 2000–2099. Não há regras de cronologia inferidas entre eventos.
- Obrigações específicas de parceiros, coerência com NOTFIS e regras de negócio externas não são verificadas. O resultado sem erros significa conformidade com as regras implementadas, não homologação pelo parceiro.

As posições são contadas a partir de 1 e o layout presume caracteres de um byte. UTF-8 com caracteres acentuados pode ocupar mais bytes que posições; confirme a codificação acordada com o parceiro. Windows-1252 mantém a equivalência entre bytes e posições para caracteres suportados.

## GitHub Pages

O repositório atual tem raiz em `D:\Diretorio`, portanto o workflow está em `../.github/workflows/ocoren-pages.yml` e executa a aplicação na subpasta `TypeScript`.

1. Envie os arquivos do projeto e o workflow ao repositório desejado (branch `main` ou `master`).
2. Em **Settings → Pages → Build and deployment → Source**, selecione **GitHub Actions**.
3. Execute **Publicar validador OCOREN** ou faça push. O workflow testa, compila e publica `TypeScript/dist`.

O Vite usa `base: './'`, conforme a estratégia de caminhos relativos da [documentação oficial de deploy do Vite](https://vite.dev/guide/static-deploy.html), compatível com páginas em subdiretórios e domínios próprios, sem precisar fixar o nome do repositório. Não há roteamento dependente de servidor. Se usar `TypeScript` como raiz de um repositório independente, mova o workflow para `.github/workflows` dessa raiz e remova `working-directory: TypeScript`; altere os caminhos de cache e artefato para `package-lock.json` e `dist`.

Para publicar manualmente, envie o conteúdo de `dist` ao branch escolhido para Pages. Não publique `.tools` nem `node_modules`.

Os testes de navegador usam Chrome instalado localmente (`npm run test:e2e`); os testes do validador e a compilação não dependem de navegador. A política de conteúdo bloqueia recursos e conexões externas da aplicação. Software do sistema e extensões do navegador podem ter comportamento de rede independente.
