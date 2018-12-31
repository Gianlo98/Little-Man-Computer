%%%% Mode: -*- Prolog -*-

%%%% file LMC.pl

%%%% Devo controllare valore istruzioni corrette es: INP 49 (errato o
%%%% fa solo input ?)


%%%% Rappresentazione dello stato
%%%% state(Acc, Pc, Mem, In, Out, Flag).



%%%% Mappa Valore-Istruzione

lmc_instruction(100, 199, instruction_add).
lmc_instruction(200, 299, instruction_sub).
lmc_instruction(300, 399, instruction_store).
lmc_instruction(500, 599, instruction_load).
lmc_instruction(600, 699, instruction_jump).
lmc_instruction(700, 799, instruction_beqz).
lmc_instruction(800, 899, instruction_bif).
lmc_instruction(901, 901, instruction_input).
lmc_instruction(902, 902, instruction_output).
lmc_instruction(0, 99, instruction_halt).

lmc_text_instruction("ADD", text_instruction_add).
lmc_text_instruction("SUB", text_instruction_sub).
lmc_text_instruction("STA", text_instruction_sta).
lmc_text_instruction("LDA", text_instruction_lda).
lmc_text_instruction("BRA", text_instruction_bra).
lmc_text_instruction("BRZ", text_instruction_brz).
lmc_text_instruction("BRP", text_instruction_brp).
lmc_text_instruction("INP", text_instruction_inp).
lmc_text_instruction("OUT", text_instruction_out).
lmc_text_instruction("HLT", text_instruction_hlt).
lmc_text_instruction("DAT", text_instruction_dat).

%%%% Goal per l'esecuzione delle istruzioni
instruction_add(state(Acc, Pc, Mem, In, Out, _Flag), state(NAcc, NPc, Mem, In, Out, NFlag)) :-
    nth0(Pc, Mem, Cell),
    IsaV is Cell mod 100,
    nth0(IsaV, Mem, CellV),
    NVal is Acc + CellV,
    NAcc is NVal mod 1000,
    NPc is Pc + 1 mod 100,
    lmc_arithmetic_flag(NAcc, NFlag).

instruction_sub(state(Acc, Pc, Mem, In, Out, _Flag), state(NAcc, NPc, Mem, In, Out, NFlag)) :-
    nth0(Pc, Mem, Cell),
    IsaV is Cell mod 100,
    nth0(IsaV, Mem, CellV),
    NVal is Acc - CellV,
    NAcc is NVal mod 1000,
    NPc is Pc + 1 mod 100,
    lmc_arithmetic_flag(NVal, NFlag).

instruction_store(state(Acc, Pc, Mem, In, Out, Flag), state(Acc, NPc, NMem, In, Out, Flag)) :-
    nth0(Pc, Mem, Cell),
    CellV is Cell mod 100,
    list_replace_index(CellV, Acc, Mem, NMem),
    NPc is Pc + 1.

instruction_load(state(_Acc, Pc, Mem, In, Out, Flag), state(NAcc, NPc, Mem, In, Out, Flag)) :-
    nth0(Pc, Mem, Cell),
    IsaV is Cell mod 100,
    nth0(IsaV, Mem, NAcc),
    NPc is Pc + 1 mod 100.

instruction_jump(state(Acc, Pc, Mem, In, Out, Flag), state(Acc, NPc, Mem, In, Out, Flag)) :-
    nth0(Pc, Mem, Cell),
    NPc is Cell mod 100.

instruction_beqz(state(0, Pc, Mem, In, Out, noflag), state(0, NPc, Mem, In, Out, noflag)) :-
   !,
   nth0(Pc, Mem, Cell),
   NPc is Cell mod 100.

instruction_beqz(state(Acc, Pc, Mem, In, Out, Flag), state(Acc, NPc, Mem, In, Out, Flag)) :-
   !,
   NPc is Pc + 1 mod 100.

instruction_bif(state(Acc, Pc, Mem, In, Out, noflag), state(Acc, NPc, Mem, In, Out, noflag)) :-
   !,
   nth0(Pc, Mem, Cell),
   NPc is Cell mod 100.

instruction_bif(state(Acc, Pc, Mem, In, Out, flag), state(Acc, NPc, Mem, In, Out, flag)) :-
   !,
   NPc is Pc + 1 mod 100.

instruction_input(state(_Acc, Pc, Mem, [X | Xs], Out, Flag), state(X, NPc, Mem, Xs, Out, Flag)) :-
   NPc is Pc + 1 mod 100.

instruction_output(state(Acc, Pc, Mem, In, Out, Flag), state(Acc, NPc, Mem, In, NOut, Flag)) :-
   append(Out, [Acc], NOut),
   NPc is Pc + 1 mod 100,
   true.

instruction_halt(state(Acc, Pc, Mem, In, Out, Flag), halted_state(Acc, Pc, Mem, In, Out, Flag)).

text_instruction_add([_I, V], C) :-
    atom_number(V, Vn),
    !,
    between(0, 99, Vn),
    C is Vn + 100.

text_instruction_add([_I, L], C) :-
    label(L, V),
    !,
    C is V + 100.

text_instruction_sub([_I, V], C) :-
    atom_number(V, Vn),
    !,
    between(0, 99, Vn),
    C is Vn + 200.

text_instruction_sub([_I, L], C) :-
    label(L, V),
    !,
    C is V + 200.

text_instruction_sta([_I, V], C) :-
    atom_number(V, Vn),
    !,
    between(0, 99, Vn),
    C is Vn + 300.

text_instruction_sta([_I, L], C) :-
    label(L, V),
    !,
    C is V + 300.

text_instruction_lda([_I, V], C) :-
    atom_number(V, Vn),
    !,
    between(0, 99, Vn),
    C is Vn + 500.

text_instruction_lda([_I, L], C) :-
    label(L, V),
    !,
    C is V + 500.

text_instruction_bra([_I, V], C) :-
    atom_number(V, Vn),
    !,
    between(0, 99, Vn),
    C is Vn + 600.

text_instruction_bra([_I, L], C) :-
    label(L, V),
    !,
    C is V + 600.

text_instruction_brz([_I, V], C) :-
    atom_number(V, Vn),
    !,
    between(0, 99, Vn),
    C is Vn + 700.

text_instruction_brz([_I, L], C) :-
    label(L, V),
    !,
    C is V + 700.

text_instruction_brp([_I, V], C) :-
    atom_number(V, Vn),
    !,
    between(0, 99, Vn),
    C is Vn + 800.

text_instruction_brp([_I, L], C) :-
    label(L, V),
    !,
    C is V + 800.

text_instruction_inp( _, 901).
text_instruction_out( _, 902).
text_instruction_hlt( _, 0).

text_instruction_dat([_I, V], Vn) :-
    atom_number(V, Vn),
    !,
    between(0, 999, Vn).

text_instruction_dat([_I], VD) :-
    !,
    text_instruction_dat(["DAT", "0"], VD).




%%%% Restituisce il relativo goal in base al numero X
lmc_instruction_goal(X, GOAL) :-
    number(X),
    lmc_instruction(L, H, GOAL),
    between(L, H, X),
    !.

one_instruction(state(Acc, Pc, Mem, In, Out, Flag), NewState) :-
    nth0(Pc, Mem, Instruction),
    lmc_instruction_goal(Instruction, Goal),
    call(Goal, state(Acc, Pc, Mem, In, Out, Flag), NewState).


%%%% Chiedere se basta invertire i predicati e mettere State come args.
execution_loop(state(Acc, Pc, Mem, In, Out, Flag), NOut) :-
    !,
    one_instruction(state(Acc, Pc, Mem, In, Out, Flag), NewState),
    execution_loop(NewState, NOut).

execution_loop(halted_state(_Acc, _Pc, _Mem, _In, Out, _Flag), Out) :-
    !.

%%%% lmc_run/3
%
%
%
%

lmc_run(Filename, In, Out) :-
    lmc_load(Filename, Mem),
    execution_loop(state(0, 0, Mem, In, [], noflag), Out).


%%%% lmc_load/2
%
%
%     FUNZIONE PRINCIPALE
%

lmc_load(Filename, Mem) :-
    filename_to_list(Filename, CodeList),
    lmc_generate_mem(CodeList, Mem).


lmc_generate_mem(CodeList, NewMem) :-
    retractall(label(_,_)),
    check_instruction_cell(CodeList, 0, NewCodeList),
    randseq(99, 99, SMem),
    append(SMem, [0], Mem),
    set_mem_value(NewCodeList, Mem, NewMem).


set_mem_value([[Instruction | V] | Xs], [_C | Ys], [CellValue | Zs]):-
    !,
    lmc_text_instruction(Instruction, Goal),
    call(Goal, [Instruction | V] , CellValue),
    set_mem_value(Xs, Ys, Zs).

set_mem_value([], Mem, Mem) :-
    !. 

%%%% lmc_arithmetic_flag/2
% lmc_arithmetic_flag(Value, Flag)
%
% Value è il valore da considerare
% Flar ha valore noflag se 0 < Value < 999 altrimenti ha valore flag
%

lmc_arithmetic_flag(X, noflag) :-
    between(0, 999, X),
    !.

lmc_arithmetic_flag(_X, flag) :-
    !.

%%%% list_replace_index/4
% list_replace_indez(Index, NewElement, OldList, NewList)
%
% Index è l'indice (parte da 0) dove rimpiazzare l'elemento
% NewElement è il nuovo elemento da mettere all'indice Index
% OldList è la lista dove effetturare il rimpiazzamento
% NewList è la lista con l'elemento rimpiazzato

list_replace_index(Index, NewElement, [X | Xs], [X | Ys]) :-
    compare(>, Index, 0),
    !,
    NIndex is Index - 1,
    list_replace_index(NIndex, NewElement, Xs, Ys).

list_replace_index(0, NewElement, [_OldElement | Xs], [NewElement | Xs]) :-
    !.

%%%% check_instruction_cell/3
% chek_instruction_cell(LAssemblyLabeledCode, Cell, LAssemblyCode)
%
%  ListOfListOfCode è la lista del codice assembly. Ciascuna riga di
%  codice è a sua volta dentro una lista di stringhe dove ciascuna
%  stringa è sequenzialmente una label (opzionale), un'istruzione e un
%  valore/label (opzionale per alcune istruzioni)
%
%  Cell è il valore della cella a cui associare la label


check_instruction_cell([[L, I, V] | Xs], C, [[I, V] | Ys]) :-
    !,
    lmc_text_instruction(I, _Pred),
    assert(label(L, C)),
    NC is C + 1,
    check_instruction_cell(Xs, NC, Ys).

check_instruction_cell([[I, V] | Xs], C, [[I, V] | Ys]) :-
    lmc_text_instruction(I, _Pred),
    !,
    NC is C + 1,
    check_instruction_cell(Xs, NC, Ys).

check_instruction_cell([[L, I] | Xs], C ,[[I] | Ys] ) :-
    lmc_text_instruction(I, _Pred),
    !,
    assert(label(L, C)),
    NC is C + 1,
    check_instruction_cell(Xs, NC, Ys).

check_instruction_cell([[I] | Xs], C, [[I] | Ys]) :-
    lmc_text_instruction(I, _Pred),
    !,
    NC is C + 1,
    check_instruction_cell(Xs, NC, Ys).

check_instruction_cell([], _, []) :-
    !.

%%%% filename_to_list/2
% filename_to_list(Filename, List)
%
% Filename nome del file da leggere
%
% List lista risultate dalla lettura priva di spazi e commenti

filename_to_list(Filename, List) :-
    open(Filename, read, In),
    input_to_list_string(In, 1, List).

%%%% input_to_list_string/3
%input_to_list_string(In, End, List)
%
% In è lo stream di input
%
% End se settato a -1 indica che ho raggiunto la fine del file
%
% List Lista di stringhe


input_to_list_string(In, End, List) :-
    compare(>, End, 0),
    !,
    read_string(In, "\n", " ", Sep, S),
    input_to_list_string(In, Sep, Out),
    split_string(S, " ", " ", Ss),
    delete_list_comments(Ss, Sf),
    custom_append([Sf], Out, List).

input_to_list_string(In, -1, []) :-
    !,
    close(In).

%%%% custom_append/3
% custom_append(List1, List2, List1List2)
%
% Uguale a un'append ma se la lista 1 è una lista contenente una lista
% vuota la ignora

custom_append([[""]], Y, Y) :-
    !.

custom_append([[]], Y, Y) :-
    !.

custom_append(X, Y, Z) :-
    !,
    append(X, Y, Z).

%%%% delete_list_comments/2
% delete_list_comments(List, ListNoComments)
%
% List è una lista di stringhe che possono includere commenti
%
% ListNoComments è la stessa lista di prima purgata dai commenti tutta in uppercase

delete_list_comments(List, ListNoComments) :-
    is_list(List),
    parse_list_element(List, nocomment, ListNoComments ).

%%%% parse_list_element/3
% parse_list_element(List, Flag, ListNoComments))
%
% List è una lista di stringhe che possono includere commenti
%
% Flag è un flag che indica se è stato trovato o meno un commento dentro
% la lista
%
% ListNoComments è la stessa lista di prima purgata dai commenti

parse_list_element([X | Xs], nocomment, ListNoComments) :-
    !,
    findall(B, sub_string(X, B, 2, _A, "//"), Ls),
    string_upper(X, XU),
    purge_element_comment(XU, Ls, ListElement, Comment),
    parse_list_element(Xs, Comment, Ys),
    custom_append([ListElement], Ys, ListNoComments).

parse_list_element(_, comment, []) :-
    !.

parse_list_element([], _, []) :-
    !.

%%%% purge_element_comment/4
% purge_element_comment(Element, [DoubleBackSlashPositions],
% ElementPurged, Comment).
%
% Element è la potenziale stringa che potrebbe contenere un commento
%
% [DoubleBackSlashPositions] non è molto elegante ma è una soluzione
% a commenti del tipo //commento//fastidiosissimo
%
% ElementPurged elemento purgato dagli eventuali commenti attaccati
%
% Comment è un flag che mi dice se ha trovato un commento o no
%

purge_element_comment(X, [], X, nocomment) :-
    !.

purge_element_comment(_, [0 | _], [], comment) :-
    !.

purge_element_comment(X, [Y], Xp, comment) :-
    !,
    sub_string(X, 0, Y, _, Xp).

%%%% end of file LMC.pl
