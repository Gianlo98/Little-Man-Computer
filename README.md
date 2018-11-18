
# Little Man Computer		
PROGETTO DEL CORSO DI LINGUAGGI DI PROGRAMMAZIONE, Università degli Studi Milano Bicocca as. 2018/19.
Questa repo contiene il codice scritto in linguaggio [Prolog](http://www.swi-prolog.org/) del progetto

![LMC](https://i.ytimg.com/vi/6cbJWV4AGmk/maxresdefault.jpg)

## OVERVIEW DEL PROGETTO

Il little man computer (LMC) è un semplice modello di computer creato per scopi didattici. Esso possiede 100 celle di memoria (numerate da 0 a 99) ognuna della quali può contenere un numero da 0 a 999 (estremi inclusi). Il computer possiede un solo registro, detto accumulatore, una coda di input ed una coda di output. LMC possiede un numero limitato di tipi di istruzioni ed un equivalente assembly altrettanto semplificato. Lo scopo del progetto è quello di produrre A. Un simulatore del LMC che dato il contenuto iniziale delle memoria (una lista di 100 numeri) e una sequenza di valori di input simuli il comportamento del LMC e produca il contenuto della coda di output dopo l’arresto del LMC. B. Un assembler che, dato un file scritto nell’assembly semplificato del LMC produca il contenuto iniziale della memoria. La parte rimanente di questo testo dettaglierà l’architettura del LMC, la sintassi dell’assembly e i predicati/funzioni che le implementazioni in Prolog e Common Lisp devono implementare.

## ARCHITETTURA DEL LMC

Il LMC è composto dalle seguenti componenti: 
 - Una **memoria** di 100 celle numerate tra 0 e 99. Ogni cella può contenere un numero tra 0 e 999. Non viene effettuata alcuna distinzione tra dati e istruzioni: a seconda del momento il contenuto di una certa cella può essere interpretato come un’istruzione (con una semantica che verrà spiegata in seguito) oppure come un dato (e, ad esempio, essere sommato ad un altro valore).
 - Un **registro accumulatore** (inizialmente zero).
 - Un **program counter**. Il program counter contiene l’indirizzo dell’istruzione da eseguire ed è inizialmente zero. Se non viene sovrascritto da altre istruzioni (salti condizionali e non condizionali) viene incrementato di uno ogni volta che un’istruzione viene eseguita. Se raggiunge il valore 999 e viene incrementato il valore successivo è zero.
 -  Una **coda di input**. Questa coda contiene tutti i valori forniti in input al LMC, che sono necessariamente numeri compresi tra 0 e 999. Ogni volta che l’LMC legge un valore di input esso viene eliminato dalla coda.
 - Una **coda di output**. Questa coda è inizialmente vuota e contiene tutti i valori mandati in output dal LMC, che sono necessariamente numeri compresi tra 0 e 999. La coda è strutturata in modo tale da avere in testa il primo output prodotto e come ultimo elemento l’ultimo output prodotto: i valori di output sono quindi in ordine cronologico.
 - Un **flag**. Ovvero un singolo bit che può essere acceso o spento. Inizialmente esso è zero (flag assente). Solo le istruzioni aritmetiche modificano il valore del flag e, in particolare, un flag a uno (flag presente) indica che l’ultima operazione aritmetica eseguita ha prodotto un risultato maggiore di 999 o minore di 0. Un flag assente indica invece che il valore prodotto dall’ultima operazione aritmetica ha prodotto un risultato compreso tra 0 e 999. 1 di 9 La seguente tabella rappresenta come le istruzioni presenti in memoria debbano essere interpretate:

Alcuni devi valori non corrispondono a nessuna istruzione. Ad esempio tutti i numeri tra 400 e 499 non hanno un corrispettivo. Questo significa che corrispondono a delle istruzioni non valide (illegal instructions) e che LMC si fermerà con una condizione di errore. 

|    Valore      |Nome Istruzione                |Significato                  |
|----------------|-------------------------------|-----------------------------|
|1xx|`Addizione`            |Somma il contenuto della cella di memoria xx con il valore contenuto nell’accumulatore e scrive il valore risultante nell’accumulatore. Il valore salvato nell’accumulatore è la somma modulo 1000. Se la somma non supera 1000 il flag è impostato ad assente, se invece raggiunge o supera 1000 il flag è impostato a presente.           |
|2xx          |`Sottrazione`            |Sottrae il contenuto della cella di memoria xx dal valore contenuto nell’accumulatore e scrive il valore risultante nell’accumulatore. Il valore salvato nell’accumulatore è la differenza modulo 1000. Se la differenza è inferiore a zero il flag è impostato a presente, se invece è positiva o zero il flag è impostato ad assente.         |
|3xx|`Store`|Salva il valore contenuto nell’accumulatore nella cella di memoria avente indirizzo xx. Il contenuto dell’accumulatore rimane invariato.|
|5xx          |`Load`            |Scrive il valore contenuto nella cella di memoria di indirizzo xx nell’accumulatore. Il contenuto della cella di memoria rimane invariato.          |
|6xx|`Branch`|Salto non condizionale. Imposta il valore del program counter a xx.|
|7xx|`Branch if zero`            |Salto condizionale. Imposta il valore del program counter a xx solamente se il contenuto dell’accumulatore è zero e se il flag è assente.        |
|8xx          |`Branch if positive`            |Salto condizionale. Imposta il valore del program counter a xx solamente se il flag è assente.           |
|901|`Input`|Scrive il contenuto presente nella testa della coda in input nell’accumulatore e lo rimuove dalla coda di input.|
|902|`Output`|Scrive il contenuto dell’accumulatore alla fine della coda di output. Il contenuto dell’accumulatore rimane invariato.|
|0xx|`Halt`|Termina l’esecuzione del programma. Nessuna ulteriore istruzione viene eseguita.|

Quindi, ad esempio, se l’accumulatore contiene il valore 42, il program counter ha valore 10 ed il contenuto della cella numero 10 è 307, il LMC eseguirà una istruzione di store, dato che il valore è nella forma 3xx. In particolare, il contenuto dell’accumulatore, ovvero 42, verrà scritto nella cella di memoria numero 7 (dato che xx corrisponde a 07). Il program counter verrà poi incrementato di uno, assumendo il valore 11. La procedura verrà ripetuta finché non verrà incontrata un’istruzione di halt o un’istruzione non valida.
