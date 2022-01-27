#!/bin/bash
#

#Inicio solicitação de usuario do banco de dados
clear

echo ""
echo "                       * INSTALAÇÃO ISSABEL- PESQUISA DE SATISFAÇÃO *"
echo ""
echo "Responda as questões abaixo corretamente para que possamos realizar todas as configurações."
echo ""
echo ""
read -p "Digite o usuário do Banco de Dados: " int1
echo ""
echo ""
read -p "Digite a senha do Bando de Dados: " int2
echo ""
echo ""
read -p "Digite o domínio do PABX: " int3
echo ""
echo ""

#Fim solicitação de usuario do banco de dados



#Inicio animacao inicial

function ProgressBar {

    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done

    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}
_start=1
_end=100

for number in $(seq ${_start} ${_end})
do
    sleep 0.03
    ProgressBar ${number} ${_end}
done

#Fim animacao inicial

clear

#Inicio preparando arquivo db_func 

wget -c https://raw.githubusercontent.com/patryckpinhal/issabel-pesquisa-satisfacao/main/db_func.php
chmod +x db_func.php
chown asterisk:asterisk db_func.php
mv db_func.php /var/lib/asterisk/agi-bin/
echo "Arquivo db_func.php finalizado com sucesso!"

#Fim preparando arquivo db_func 

clear

#Inicio preparando arquivo dbconnection.php 

wget -c https://raw.githubusercontent.com/patryckpinhal/issabel-pesquisa-satisfacao/main/dbconnection.php
chmod +x dbconnection.php
chown asterisk:asterisk dbconnection.php

sed -i 's/mudaruser/'$int1'/g' dbconnection.php
sed -i 's/mudarsenha/'$int2'/g' dbconnection.php

mv dbconnection.php /var/lib/asterisk/agi-bin/

echo "Arquivo dbconnection.php finalizado com sucesso!"

#Fim preparando arquivo dbconnection.php

clear

#Inicio preparando arquivo pesquisa.php 

wget -c https://raw.githubusercontent.com/patryckpinhal/issabel-pesquisa-satisfacao/main/pesquisa.php
chmod +x pesquisa.php
chown asterisk:asterisk pesquisa.php
mv pesquisa.php /var/lib/asterisk/agi-bin/
echo "Arquivo pesquisa.php finalizado com sucesso!"

#Fim preparando arquivo pesquisa.php

clear

#Inicio preparando arquivo extensions_custom.conf

echo "" >> /etc/asterisk/extensions_custom.conf
echo "; Inicio configuração pesquisa de satisfação" >> /etc/asterisk/extensions_custom.conf
echo "" >> /etc/asterisk/extensions_custom.conf
echo "[from-ura-pesquisa]" >> /etc/asterisk/extensions_custom.conf
echo "exten => s,1,Noop(Pesquisa de satisfação)" >> /etc/asterisk/extensions_custom.conf
echo "same => n,AGI(pesquisa.php, "'${STRFTIME(${EPOCH},,%Y-%m-%d %H:%M:%S)}'", https://mudardominio/index.php?menu=monitoring&action=download&id="'${UNIQUEID}&namefile=${CDR(recordingfile)}&rawmode=yes, ${QUEUENUM}, ${CALLERID(number)}, ${CONNECTEDLINE(name)}, ${IVR_DIGIT_PRESSED}) '"" >> /etc/asterisk/extensions_custom.conf
echo "same => n,Playback(custom/audio-pesquisa-2)" >> /etc/asterisk/extensions_custom.conf
echo "same => n,Hangup()" >> /etc/asterisk/extensions_custom.conf
echo "" >> /etc/asterisk/extensions_custom.conf
echo "; Fim configuração pesquisa de satisfação" >> /etc/asterisk/extensions_custom.conf
echo "" >> /etc/asterisk/extensions_custom.conf

sed -i 's/mudardominio/'$int3'/g' /etc/asterisk/extensions_custom.conf

#Fim preparando arquivo extensions_custom.conf

clear

#Inicio preparando banco pesquisa_satisfacao

wget -c https://raw.githubusercontent.com/patryckpinhal/issabel-pesquisa-satisfacao/main/pesquisa_satisfacao.sql
mysqladmin -u $int1 -p$int2 create pesquisa_satisfacao
mysql -u $int1 -p$int2 pesquisa_satisfacao < pesquisa_satisfacao.sql
rm -rf pesquisa_satisfacao.sql

#Fim preparando banco pesquisa_satisfacao

clear

#Inicio download audio e alocando na pasta correta

wget -c https://github.com/patryckpinhal/issabel-pesquisa-satisfacao/raw/main/audio-pesquisa-2.wav
mv audio-pesquisa-2.wav /var/lib/asterisk/sounds/custom/

#Fim download audio e alocando na pasta correta

clear

#Inicio aviso de primeira parte de configuração web

echo " ############################################################################################################### "
echo " #                                                                                                             # "
echo " #          Para dar continuidade no processo de instalação, é necessário a criação de um modulo web           # "
echo " #   através do Addons Developer, que pode ser instalado através da interface Web do Issabel, navegando em:    # "
echo " #                                                                                                             # "
echo " #                                         Addons -> Addons                                                    # "
echo " #                                                                                                             # "
echo " #                   E pressionando em INSTALL em Developer - 4.0.0-2 ou superior.                             # "
echo " #                                                                                                             # "
echo " #                                                                                                             # "
echo " #                                                                                                             # "
echo " #         Após a instalação, navegue em Developer > Build Module, e preencha da seguinte forma:               # "
echo " #                                                                                                             # "
echo " #           Module Name.................= Pesquisa de Satisfação                                              # "
echo " #           Your Name...................= Seu Nome                                                            # "
echo " #           Your e-mail.................= qualquer@qualquer                                                   # "
echo " #           Module Level................= Level 2                                                             # "
echo " #           Level 1 Parent Exists.......= Yes                                                                 # "
echo " #           Level 1 Parent..............= Reports                                                             # "
echo " #           Module Type.................= Grid                                                                # "
echo " #           Após preencher corretamente, pressione em *Save*                                                  # "
echo " #                                                                                                             # "
echo " ############################################################################################################### "

echo ""
while [[ $int4 != "yes" ]];
do
read -p "Após a finalização das configurações, digite yes para que possamos dar continuidade nas instalações: " int4;
done

#Fim aviso de primeira parte de configuração web

clear

#Inicio configurando interface web

wget -c https://github.com/patryckpinhal/issabel-pesquisa-satisfacao/raw/main/web.tgz
rm -rf /var/www/html/modules/pesquisa_de_satisfa_o/*
mv web.tgz /var/www/html/modules/pesquisa_de_satisfa_o/
cd /var/www/html/modules/pesquisa_de_satisfa_o/
tar -zxvf web.tgz
rm -rf web.tgz
cd /

#Fim configurando interface web

clear

#Inicio continuacao interface web

echo " #################################################################################################### "
echo " #                                                                                                  # "
echo " #     Para finalizar as configurações precisamos realizar alguns passos fundamentais.              # "
echo " #                                                                                                  # "
echo " #                                                                                                  # "
echo " #       Realize o download em seu computador do áudio de pesquisa através do link:                 # "
echo " #   https://github.com/patryckpinhal/issabel-pesquisa-satisfacao/raw/main/audio-pesquisa-1.wav     # "
echo " #                                                                                                  # "
echo " #__________________________________________________________________________________________________# "
echo " #                                                                                                  # "
echo " #         * Passo 1 - Navegue dentro do Issabel para:                                              # "
echo " #                                                                                                  # "
echo " #                        PBX -> PBX Configuration -> System Recordings                             # "
echo " #                                                                                                  # "
echo " #           Suba o áudio baixado anteriormente, e nomeie da seguinte forma:                        # "
echo " #                                audio-pesquisa-1                                                  # "
echo " #__________________________________________________________________________________________________# "
echo " #                                                                                                  # "
echo " #                                                                                                  # "
echo " #         * Passo 2 - Navegue dentro do Issabel para:                                              # "
echo " #                                                                                                  # "
echo " #                        PBX -> PBX Configuration -> Custom Destination                            # "
echo " #                                                                                                  # "
echo " #           Preencha os campos da seguinte forma:                                                  # "
echo " #           - Custom Destination     = from-ura-pesquisa,s,1                                       # "
echo " #           - Description            = from-ura-pesquisa                                           # "
echo " #                                                                                                  # "
echo " #                   Após preencher corretamente, pressione em *Submit Changes*.                    # "
echo " #                                                                                                  # "
echo " #__________________________________________________________________________________________________# "
echo " #                                                                                                  # "
echo " #                                                                                                  # "
echo " #         * Passo 3 - Navegue dentro do Issabel para:                                              # "
echo " #                                                                                                  # "
echo " #                        PBX -> PBX Configuration -> IVR                                           # "
echo " #                                                                                                  # "
echo " #           Crie uma IVR selecionando em Annoucement o audio audio-pesquisa-1.                     # "
echo " #                                                                                                  # "
echo " #           Tambem será necessário criar as opções 1, 2, 3, 4 e 5, redirecionando todas para:      # "
echo " #                         Custom Destinations -> from-ura-pesquisa                                 # "
echo " #                                                                                                  # "
echo " #__________________________________________________________________________________________________# "
echo " #                                                                                                  # "
echo " #                                                                                                  # "
echo " #         * Passo 4 - Após finalizar estas configurações, acesse:                                  # "
echo " #                                                                                                  # "
echo " #                        PBX -> PBX Configuration -> Queues                                        # "
echo " #                                                                                                  # "
echo " #           E ative em todas as filas desejadas, selecionando a IVR criada anteriormente no campo: # "
echo " #                              Queue Continue Destination                                          # "
echo " #                                                                                                  # "
echo " #################################################################################################### "

#Fim continuacao interface web



#Inicio finalizacao

echo ""
while [[ $int5 != "yes" ]];
do
read -p "Após a finalização das configurações, o software já pode ser utilizado normalmente. Digite yes para finalizar: " int5;
done

clear

function ProgressBar {

    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done

    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}
_start=1
_end=100

for number in $(seq ${_start} ${_end})
do
    sleep 0.03
    ProgressBar ${number} ${_end}
done
clear
echo "Script finalizado com sucesso! Obrigado!"

#Fim finalizacao
