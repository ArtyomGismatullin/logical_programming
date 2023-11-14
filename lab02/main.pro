implement main
    open core, stdio, file

domains
    status = silver; gold; vip.

class facts - buyingsDb
    товар : (integer Id, string ProductName, string Category, integer Price) nondeterm.
    клиент : (string Name, integer64 Number, status Status) nondeterm.
    покупка : (integer64 Number, integer Id, integer Amount, string Date) nondeterm.

class predicates
    сумма_покупок_на_день : (string Date, integer Summa) nondeterm anyflow.
clauses
    сумма_покупок_на_день(Дата, Сумма) :-
        покупка(_, Id, Количество, Дата),
        товар(Id, _, _, Цена),
        Сумма = Количество * Цена.

class predicates
    имена_купивших_товар : (string Товар, string Клиент) nondeterm anyflow.
clauses
    имена_купивших_товар(Товар, Клиент) :-
        товар(Id, Товар, _, _),
        клиент(Клиент, Телефон, _),
        покупка(Телефон, Id, _, _).

class predicates
    товары_купленные_в_этот_день : (string Товар, string Дата) nondeterm anyflow.
clauses
    товары_купленные_в_этот_день(Товар, Дата) :-
        товар(Id, Товар, _, _),
        покупка(_, Id, _, Дата).

class predicates
    сумма_покупки_клиента : (string Клиент, string Товар, integer Сумма) nondeterm anyflow.
clauses
    сумма_покупки_клиента(Клиент, Товар, Сумма) :-
        клиент(Клиент, Телефон, _),
        товар(Id, Товар, _, Цена),
        покупка(Телефон, Id, Количество, _),
        Сумма = Цена * Количество.

clauses
    run() :-
        consult("../buyings.txt", buyingsDb),
        fail.

    run() :-
        write('01.01.2022 были совершены покупки на следующие суммы:\n'),
        сумма_покупок_на_день('01.01.2022', A),
        write(A),
        nl,
        fail.

    run() :-
        write('Говядину купили следующие клиенты:\n'),
        имена_купивших_товар('Говядина', A),
        write(A),
        nl,
        fail.

    run() :-
        write('Алиса за все время купила следующие товары:\n'),
        сумма_покупки_клиента('Алиса', Товар, Сумма),
        write('Товар: '),
        write(Товар),
        write('\nСтоимость: '),
        write(Сумма),
        nl,
        fail.

    run() :-
        write('Следующие товары были куплены 02.01.2022:\n'),
        товары_купленные_в_этот_день(Товары, '02.01.2022'),
        write(Товары),
        nl,
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).
/*Вывод программы:
01.01.2022 были совершены покупки на следующие суммы:
200
400
150
120
240
Говядину купили следующие клиенты:
Иван
Федор
Алиса за все время купила следующие товары:
Товар: Помидоры
Стоимость: 150
Товар: Помидоры
Стоимость: 225
Товар: Огурцы
Стоимость: 120
Следующие товары были куплены 02.01.2022:
Яблоки
Говядина
Курица
Окунь
Груши
*/
