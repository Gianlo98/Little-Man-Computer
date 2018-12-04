%%%% Mode: -*- Prolog -*-

%%%% file LMC.pl




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

%%%% Goal per l'esecuzione delle istruzioni

lmc_arithmetic_flag(X, noflag) :-
    between(0, 999, X),
    !.
lmc_arithmetic_flag(_X, flag) :-
    !.

list_replace_index(Index, NewElement, [X | Xs], [X | Ys]) :-
    compare(>, Index, 0),
    !,
    NIndex is Index - 1,
    list_replace_index(NIndex, NewElement, Xs, Ys).

list_replace_index(0, NewElement, [_OldElement | Xs], [NewElement | Xs]) :-
    !.


instruction_add(state(Acc, Pc, Mem, In, Out, _Flag), state(NAcc, NPc, Mem, In, Out, NFlag)) :-
    nth0(Pc, Mem, Cell),
    IsaV is Cell mod 100,
    nth0(IsaV, Mem, CellV),
    NVal is Acc + CellV,
    NAcc is NVal mod 1000,
    NPc is Pc + 1,
    lmc_arithmetic_flag(NAcc, NFlag).

instruction_sub(state(Acc, Pc, Mem, In, Out, _Flag), state(NAcc, NPc, Mem, In, Out, NFlag)) :-
    nth0(Pc, Mem, Cell),
    IsaV is Cell mod 100,
    nth0(IsaV, Mem, CellV),
    NVal is Acc - CellV,
    NAcc is NVal mod 1000,
    NPc is Pc + 1,
    lmc_arithmetic_flag(NVal, NFlag).

instruction_store(state(Acc, Pc, Mem, In, Out, Flag), state(Acc, NPc, NMem, In, Out, Flag)) :-
    nth0(Pc, Mem, Cell),
    CellV is Cell mod 100,
    list_replace_index(CellV, Acc, Mem, NMem),
    NPc is Pc + 1.

instruction_load(state(_Acc, Pc, Mem, In, Out, Flag), state(NAcc, NPc, Mem, In, Out, Flag)) :-
    nth0(Pc, Mem, Cell),
    NAcc is Cell mod 100,
    NPc is Pc + 1.

instruction_jump(state(Acc, Pc, Mem, In, Out, Flag), state(Acc, NPc, Mem, In, Out, Flag)) :-
    nth0(Pc, Mem, Cell),
    NPc is Cell mod 100.

instruction_beqz(state(0, Pc, Mem, In, Out, noflag), state(0, NPc, Mem, In, Out, noflag)) :-
   !,
   nth0(Pc, Mem, Cell),
   NPc is Cell mod 100.

instruction_beqz(state(Acc, Pc, Mem, In, Out, Flag), state(Acc, NPc, Mem, In, Out, Flag)) :-
   !,
   NPc is Pc + 1.

instruction_bif(state(Acc, Pc, Mem, In, Out, noflag), state(Acc, NPc, Mem, In, Out, noflag)) :-
   !,
   nth0(Pc, Mem, Cell),
   NPc is Cell mod 100.

instruction_bif(state(Acc, Pc, Mem, In, Out, flag), state(Acc, NPc, Mem, In, Out, flag)) :-
   !,
   NPc is Pc + 1.

instruction_input(state(_Acc, Pc, Mem, [X | Xs], Out, Flag), state(X, NPc, Mem, Xs, Out, Flag)) :-
   NPc is Pc + 1.

instruction_output(state(Acc, Pc, Mem, In, Out, Flag), state(Acc, NPc, Mem, In, NOut, Flag)) :-
   append(Out, [Acc], NOut),
   NPc is Pc + 1,
   true.

instruction_halt(state(Acc, Pc, Mem, In, Out, Flag), halted_state(Acc, Pc, Mem, In, Out, Flag)).



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





%%%% end of file LMC.pl





