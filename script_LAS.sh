#!/bin/bash

#---------------------------------    UTENTI      ----------------------------------
gestione_utenti() {
    clear
    echo "GESTIONE UTENTI:"
    echo "1 --> Aggiungi utente"
    echo "2 --> Rimuovi utente"
    echo "3 --> Elenco utenti"
    echo "4 --> Modifica nome di un utente"
    echo "5 --> Imposta nuova password di un utente"
    echo "6 --> Esegui il backup di tutti gli utenti"
    echo "7 --> Esegui il backup di un utente specifico"
    read -p "Seleziona un'opzione: " scelta

    case $scelta in
        1)
            read -p "Inserisci nome del nuovo utente: " nome
            sudo useradd $nome
            read -p "Inserisci nuova password: " password
            echo "$nome:$password" | sudo chpasswd
            ;;
        2)
            read -p "Inserisci nome dell'utente da rimuovere: " nome
            sudo userdel $nome
            ;;
        3)
            echo "Elenco degli utenti:"
            cut -d: -f1 /etc/passwd
            ;;
            
        4)
            read -p "Inserisci nome dell'utente da modificare: " nome
            read -p "Inserisci nuovo nome: " nuovo_nome
            sudo usermod -l $nuovo_nome $nome
            ;;
            
        5)
            read -p "Inserisci nome dell'utente a cui impostare la password: " nome
            read -p "Inserisci nuova password: " new_pass
            echo "$nome:$new_pass" | sudo chpasswd
            ;;

        6)
            read -p "Inserisci il percorso completo della directory per salvare il backup: " path
            echo "Esecuzione backup utenti in corso..."
            sudo tar -czvf $path/utenti_backup_$(date +%Y%m%d%H%M%S).tar.gz /home
            echo "## Backup degli utenti completato ##"
            ;;

        7)
            read -p "Inserisci il percorso completo della directory per salvare il backup: " path
            read -p "Inserisci nome utente per il quale vuoi fare il backup: " nome
            if id "$nome" &>/dev/null; then
                sudo mkdir -p $path
                sudo cp -r /home/$nome $path
                sudo cp /etc/passwd /etc/shadow /etc/group /etc/gshadow $path
                echo "Backup dell'utente $nome completato in $path"
            else
                echo "L'utente $nome non esiste."
            fi
            ;;
        *)
            echo "Opzione non valida "
            sleep 1
            clear
            ;;
    esac
}



#---------------------------------    SERVIZI      ----------------------------------
gestione_servizi() {
    clear
    echo "GESTIONE SERVIZI:\n"
    echo " 1 --> Avvia un servizio"
    echo " 2 --> Ferma un servizio"
    echo " 3 --> Riavvia un servizio"
    echo " 4 --> Stato di un servizio"
    echo " 5 --> Stato di tutti i servizi"
    read -p "Seleziona opzione: " scelta

    case $scelta in
        1)
            read -p "Inserisci nome servizio da avviare: " servizio
            sudo systemctl start $servizio
            ;;
        2)
            read -p "Inserisci nome servizio da stoppare: " servizio
            sudo systemctl stop $servizio
            ;;
        3)
            read -p "Inserisci nome servizio da riavviare: " servizio
            sudo systemctl restart $servizio
            ;;
        4)
            read -p "Inserisci nome servizio per visualizzare lo stato: " servizio
            sudo systemctl status $servizio
            ;;
        5)
            sudo systemctl list-units --type=service --all
            ;;
        *)
            echo "Opzione non valida "
            sleep 1
            clear
            ;;
    esac
}


#---------------------------------    FILE SYSTEM      ----------------------------------
gestione_file_system() {
    clear
    echo "GESTIONE FILE SYSTEM:"
    echo "1  --> Crea una nuova cartella"
    echo "2  --> Elimina cartella e/o file"
    echo "3  --> Rinomina una cartella o file"
    echo "4  --> Modifica permessi cartella o file"
    echo "5  --> Modifica proprietario cartella o file"
    echo "6  --> Visualizza contenuto file o cartella"
    read -p "Seleziona un'opzione: " scelta

    case $scelta in
        1)
            read -p "Inserisci percorso dove creare la nuova cartella: " path
            read -p "Inserisci il nome della nuova cartella: " nome
            mkdir -p "$path/$nome"
            ;;
        2)
            read -p "Inserisci percorso del file/cartella da eliminare: " path
            read -p "Inserisci il nome del file/cartella: " nome
            sudo rm -r "$path/$nome"
            ;;
        3)
            read -p "Inserisci percorso della cartella o file da rinominare: " path
            read -p "Inserisci nuovo nome della cartella o file: " nome
            sudo mv $path $nome
            ;;
        4)
            read -p "Inserisci percorso della cartella o file: " path
            read -p "Inserisci nome file/cartella a cui vuoi modificare i permessi: " nome
            echo "Per informazioni, ecco alcuni esempi di permessi: "
            echo "777 - Tutti i permessi per tutti"
            echo "755 - Permessi completi per il proprietario, lettura ed esecuzione per gli altri"
            echo "644 - Permessi di lettura e scrittura per il proprietario, solo lettura per gli altri"
            read -p "Inserisci i nuovi permessi: " permessi
            sudo chmod $permessi "$path/$nome"
            ;;
        5)
            read -p "Inserisci percorso della cartella o file: " path
            read -p "Inserisci nome file/cartella a cui vuoi modificare il proprietario: " nome
            read -p "Inserisci il nuovo proprietario (utente:gruppo): " nuovo_proprietario
            sudo chown $nuovo_proprietario "$path/$nome"
            ;;
        6)
            read -p "Inserisci il percorso della cartella o file: " path
            read -p "Inserisci nome file/cartella che vuoi visualizzare: " nome
            if [ -d "$path/$nome" ]; then
                ls -l "$path/$nome"
            elif [ -f "$path/$nome" ]; then
                cat "$path/$nome"
            else
                echo "Percorso non valido"
            fi
            ;;
        *)
            echo "Opzione non valida "
            sleep 1
            clear
            ;;
    esac
}


#---------------------------------     RETE      ----------------------------------
gestione_rete() {
    clear
    echo "GESTIONE RETE:"
    echo "1 --> Visualizza configurazione di rete"
    echo "2 --> Mio IP"
    echo "3 --> Configura IP"
    echo "4 --> Verifica ping verso un host"
    echo "5 --> Risoluzione DNS IP -> URL"
    echo "6 --> Risoluzione DNS URL -> IP"
    read -p "Seleziona un'opzione: " scelta

    case $scelta in
        1)
            ip a
            ;;
        2)
            echo -e "\nIndirizzo IP: " $(hostname -I)
            ;;
        3)
            read -p "Inserisci interfaccia di rete (es. eth0): " interfaccia
            read -p "Inserisci indirizzo IP: " indirizzo_ip
            read -p "Inserisci subnet mask: " subnet_mask
            read -p "Inserisci gateway: " gateway
            sudo ip addr add $indirizzo_ip/$subnet_mask dev $interfaccia
            sudo ip route add default via $gateway
            ;;
        4)  
            read -p "Inserisci host da pingare: " host
            ping -c 4 $host
            ;;
        5)  
            read -p "Inserisci indirizzo IP da risolvere: " indirizzo_ip
            nslookup $indirizzo_ip
            ;;
        6)  
            read -p "Inserisci URL da risolvere: " url
            nslookup $url
            ;;
        *)
            echo "Opzione non valida "
            sleep 1
            clear
            ;;
    esac
}


#---------------------------------     PROCESSI      ----------------------------------
gestione_processi() {
    clear
    echo "GESTIONE PROCESSI:"
    echo "1 --> Visualizza processi attivi"
    echo "2 --> Killa un processo"
    read -p "Seleziona un'opzione: " scelta

    case $scelta in
        1)
            ps aux
            ;;
        2)
            read -p "Inserisci PID del processo da terminare: " pid
            sudo kill $pid
            ;;
        *)
            echo "Opzione non valida "
            sleep 1
            clear
            ;;
    esac
}


#---------------------------------     MONITORAGGIO SISTEMA      ----------------------------------
monitoraggio_sistema() {
    clear
    echo "MONITORAGGIO PRESTAZIONI SISTEMA:"
    echo "1 --> CPU"
    echo "2 --> Memoria"
    echo "3 --> Spazio su disco"
    read -p "Seleziona un'opzione: " scelta

    case $scelta in
        1)
            top -b -n1 | grep "Cpu(s)"
            ;;
        2)
            free -h
            ;;
        3)
            df -h
            ;;
        *)
            echo "Opzione non valida "
            sleep 1
            clear
            ;;
    esac
}


#---------------------------------    MENU'      ----------------------------------
while true; do
    echo -e "\n"
    echo "GESTIONE SERVER LINUX"
    echo " 1 --> Gestione utenti"
    echo " 2 --> Gestione servizi"
    echo " 3 --> Gestione file system"
    echo " 4 --> Gestione rete"
    echo " 5 --> Gestione processi"
    echo " 6 --> Monitoraggio prestazioni sistema"
    echo " 7 --> Esci"
    read -p "Seleziona opzione: " scelta

    case $scelta in
        1)
            gestione_utenti
            ;;
        2)
            gestione_servizi
            ;;
        3)
            gestione_file_system
            ;;
        4)
            gestione_rete
            ;;
        5)
            gestione_processi
            ;;
        6)
            monitoraggio_sistema
            ;;
        7)
            echo "Chiusura in corso..."
            sleep 2
            clear
            break
            ;;
        *)
            echo "Opzione non valida"
            sleep 1
            clear
            ;;
    esac
done
