# verificador-de-arquivos-MD5
Verificador arquivos é um script que tem uma só funcionalidade, verificar modificações em um determinado diretório e arquivos, gerando uma chave única MD5 para cada arquivo. Caso, um dele seja comprometido através de algum software malicioso a chave será gerada  novamente, e você será informado que tal arquivo foi modificado, (não necessariamente serão sempre softwares maliciosos).


[++++]Tem que executar o código 2 vezes para ele gerar um digest[++++]

USO: RUBY VERIFICADOR_MD5.RB 'SEU DIRETORIO' 


EX: RUBY VERIFICADOR_MD5.RB /HOME/USER/DOCUMENTS/
