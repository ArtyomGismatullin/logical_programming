% Домен статуса
статус(новый).
статус(обычный).
статус(постоянный).

% Факты о товарах (id, название, категория, цена)
товар(1, 'Яблоки', 'Фрукты', 100).
товар(2, 'Говядина', 'Мясо', 300).
товар(3, 'Курица', 'Мясо', 150).
товар(4, 'Судак', 'Рыба', 220).
товар(5, 'Окунь', 'Рыба', 200).
товар(6, 'Груши', 'Фрукты', 100).
товар(7, 'Помидоры', 'Овощи', 75).
товар(8, 'Огурцы', 'Овощи', 60).
товар(9, 'Телятина', 'Мясо', 240).
товар(10, 'Горбуша', 'Рыба', 400).

% Факты о клиентах (имя, телефон, статус)
клиент('Иван', 123456789, vip).
клиент('Петр', 987654321, silver).
клиент('Мария', 111122223, silver).
клиент('Женя', 123123242, silver).
клиент('Федор', 483821743, silver).
клиент('Дмитрий', 234753476, silver).
клиент('Артём', 485347563, silver).
клиент('Виктор', 423754374, gold).
клиент('Сергей', 472465819, silver).
клиент('Алиса', 3423427574, silver).

/*
Статус определяется суммой, потраченной в магазине. Каждый покупатель имеет первоначально
статус silver (покупок было соверешенно до 500 у.е.). Далее покупатель получает статус gold
(покупок было совершено до 1500 у.е). От суммы 1500 у.е. покупок больше клиент получает статус vip. Я определил в фактах их статусы следующим образом: не придумав, как можно сделать это функционально, я посчитал общую сумму их покупок за 3 дня и самостоятельно присвоил им соответсвующие статусы. Возможно было написать правило по определению статуса конкретного клиента на основе его всех покупок, но там необходимо было работать со списками, что представилось довольно сложным. Или же более простую идею по реализации мне не удалось найти
*/

% Факты о покупках (телефон клиента, id товара, количество, дата)
покупка(123456789, 1, 2, '01.01.2022'). % Иван купил 2 ед. яблок
покупка(123123242, 10, 1, '01.01.2022'). % Женя купила 1 ед. горбуши
покупка(3423427574, 7, 2, '01.01.2022'). % Алиса купила 2 ед. помидоров
покупка(3423427574, 8, 2, '01.01.2022'). % Алиса купила 2 ед. огурцов
покупка(485347563, 9, 1, '01.01.2022'). % Артём купил 1 ед. телятины
покупка(123456789, 2, 2, '02.01.2022'). % Иван купил 2 ед. говядины
покупка(987654321, 1, 3, '02.01.2022'). % Петр купил 3 ед. яблок
покупка(423754374, 5, 3, '02.01.2022'). % Виктор купил 3 ед. окуня
покупка(234753476, 3, 3, '02.01.2022'). % Дмитрий купил 3 ед. курицы
покупка(472465819, 6, 2, '02.01.2022'). % Сергей купил 2 ед. груш
покупка(111122223, 3, 1, '03.01.2022'). % Мария купила 1 ед. курицы
покупка(472465819, 4, 1, '03.01.2022'). % Сергей купил 1 ед. судака
покупка(123456789, 9, 5, '03.01.2022'). % Иван купил 5 ед. телятины
покупка(3423427574, 7, 3, '03.01.2022'). % Алиса купила 3 ед. помидоров
покупка(483821743, 2, 1, '03.01.2022'). % Федор купил 1 ед. говядины

% Правило для вычисления суммы покупок клиента на определенный день
сумма_покупок_на_день(Дата, Сумма) :-
    покупка(_,  Id, Количество, Дата),
    товар(Id, _, _, Цена),
    Сумма is Количество * Цена.

% Вычисление имен клиентов, купивших определенный товар
имена_купивших_товар(Товар, Клиент) :-
    товар(Id, Товар, _, _),
    клиент(Клиент, Телефон, _),
    покупка(Телефон, Id, _, _).
    
% Названия товара, купленных в определенный день
товары_купленные_в_этот_день(Товар, Дата) :-
    товар(Id, Товар, _, _),
    покупка(_,  Id, _, Дата).
    
% Сумма, которую клиент потратил на определенный товар
сумма_покупки_клиента(Клиент, Товар, Сумма) :-
    клиент(Клиент, Телефон, _),
    товар(Id, Товар, _, Цена),
    покупка(Телефон, Id, Количество, _),
    Сумма is Цена * Количество.

% Id товаров, купленных в определенный день
товары_по_дате(Дата, X) :-
    findall(Товар, покупка(_, Товар, _, Дата), Список_названий),
    list_to_set(Список_названий, X).
    
/*

Примеры запросов:

?- сумма_покупок_на_день('01.01.2022', A).
A = 200 ;
A = 400 ;
A = 150 ;
A = 120 ;
A = 240.
(Под А подразумевается сумма, потраченная на определенный товар).

?- имена_купивших_товар('Говядина', A).
A = 'Иван' ;
A = 'Федор'.

(Только Федор и Иван приобрели говядину за все время).

?- сумма_покупки_клиента('Алиса', Товар, Сумма).
Товар = 'Помидоры',
Сумма = 150 ;
Товар = 'Помидоры',
Сумма = 225 ;
Товар = 'Огурцы',
Сумма = 120.

(Алиса дважды покупала помидоры и однажды огурцы. Сумма указывается с учетом количества).

?- товары_по_дате('02.01.2022', X).
X = [2, 1, 5, 3, 6].

(Мы получили Id товаров, купленных второго января. Это говядина, яблоки, окунь, курица и груши).

?- товары_купленные_в_этот_день(Товары, '02.01.2022').
Товары = 'Яблоки' ;
Товары = 'Говядина' ;
Товары = 'Курица' ;
Товары = 'Окунь' ;
Товары = 'Груши'.

(Схожее правило с предыдущим, но реализация не при помощи списков. К тому же здесь вывод идет по названиям товаров, а не по их Id номерам).

*/
