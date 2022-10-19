# GenDown
Gerenciador de Downloads em Delphi (Prova Softplan)

Desafio de implementar um Gerenciador de Downloads com as funcionalidades descritas abaixo:

Desenvolva uma aplicação MultiThread conforme critérios de aceite:
---
- [x] DADO que acesso o sistema
   - [x] E informo o link para download,
   - [x] QUANDO clico no botão “Iniciar Download”,
   - [x] ENTÃO o sistema inicia o download
   - [x] E consigo visualizar seu progresso até sua finalização.
---
- [x] DADO que acesso o sistema E possuo um download em andamento,
   - [x] QUANDO clico no botão “Exibir mensagem”,
   - [x] ENTÃO o sistema exibe uma mensagem com a % atual de download.
---
- [x] DADO que acesso o sistema E possuo um download em andamento,
   - [x] QUANDO clico no botão “Parar download”,
   - [x] ENTÃO o sistema interrompe o download do arquivo.
---
- [x] DADO que acesso o sistema E possuo um download em andamento,
   - [x] QUANDO clico para fechar o sistema,
   - [x] ENTÃO o sistema exibe a mensagem “Existe um download em andamento, deseja interrompe-lo [Sim, Não]”.
---
- [x] DADO que acesso o sistema
   - [x] QUANDO clico no botão “Exibir histórico de downloads”,
   - [x] ENTÃO o sistema abre uma nova tela
   - [x] E exibe o histórico de downloads realizados, com suas URL’s e suas respectivas datas de início e fim.
