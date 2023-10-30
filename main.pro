implement main
    open core, stdio, file

domains
    id_shop = integer.
    id_item = integer.
    shop = string.
    address = string.
    type = string.
    model = string.
    price = integer.
    slot_type = lga; socket; pci; sata; vga; dvi; molex; pin3; pin4.

class facts - db
    магазин : (id_shop IdShop, shop Shop, address Address).
    комплектующее : (id_item IdItem, type Type, model Model).
    ррц : (id_item IdItem, price Price).
    наличие : (id_shop IdShop, id_item IdItem, price Price).
    слот : (id_item IdItem, slot_type SlotType).

class predicates
    данные_комплектующего : (type Type) failure.
    цены_на_комплектующее : (model Model) failure.
    слоты_комплектующего : (model Model) failure.
    комплектующие_по_слоту : (slot_type SlotType) failure.
    бюджетная_сборка : (price Price) failure.
    игровая_сборка : (price Price) failure.
    сборка_в_магазине : (address Address, price Price) failure.

clauses
    данные_комплектующего(TYPE) :-
        комплектующее(_, TYPE, MODEL),
        write("модель - ", MODEL),
        nl,
        fail.

    цены_на_комплектующее(MODEL) :-
        наличие(ID_SHOP, ID_C, PRICE),
        магазин(ID_SHOP, SHOP, ADDRESS),
        комплектующее(ID_C, _, MODEL),
        write("магазин - ", SHOP, " ", ADDRESS, "\nцена - ", PRICE),
        nl,
        fail.

    слоты_комплектующего(MODEL) :-
        слот(ID_C, SLOT),
        комплектующее(ID_C, _, MODEL),
        write(SLOT, " "),
        fail.

    комплектующие_по_слоту(SLOT) :-
        слот(ID_C, SLOT),
        комплектующее(ID_C, _, MODEL),
        write(MODEL),
        nl,
        fail.

    бюджетная_сборка(BUDGET) :-
        комплектующее(ID1, "процессор", MODEL_PROCESSOR),
        комплектующее(ID2, "материнская плата", MODEL_PLATA),
        комплектующее(ID3, "видеокарта", MODEL_VIDEOCARD),
        комплектующее(ID4, "кулер", MODEL_COOLER),
        ррц(ID1, PRICE1),
        ррц(ID2, PRICE2),
        ррц(ID3, PRICE3),
        ррц(ID4, PRICE4),
        PRICE = PRICE1 + PRICE2 + PRICE3 + PRICE4,
        PRICE < BUDGET,
        write("сборка: \n", MODEL_PROCESSOR, "\n", MODEL_PLATA, "\n", MODEL_VIDEOCARD, "\n", MODEL_COOLER, "\n"),
        write("общая сумма - ", PRICE),
        nl,
        nl,
        fail.

    игровая_сборка(BUDGET) :-
        комплектующее(ID1, "процессор", MODEL_PROCESSOR),
        комплектующее(ID2, "материнская плата", MODEL_PLATA),
        комплектующее(ID3, "видеокарта", MODEL_VIDEOCARD),
        комплектующее(ID4, "кулер", MODEL_COOLER),
        ррц(ID1, PRICE1),
        ррц(ID2, PRICE2),
        ррц(ID3, PRICE3),
        ррц(ID4, PRICE4),
        PRICE = PRICE1 + PRICE2 + PRICE3 + PRICE4,
        PRICE > BUDGET - 10000,
        PRICE < BUDGET,
        write("сборка: \n", MODEL_PROCESSOR, "\n", MODEL_PLATA, "\n", MODEL_VIDEOCARD, "\n", MODEL_COOLER, "\n"),
        write("общая сумма - ", PRICE),
        nl,
        nl,
        fail.

    сборка_в_магазине(ADDRESS, BUDGET) :-
        комплектующее(ID1, "процессор", MODEL_PROCESSOR),
        комплектующее(ID2, "материнская плата", MODEL_PLATA),
        комплектующее(ID3, "видеокарта", MODEL_VIDEOCARD),
        комплектующее(ID4, "кулер", MODEL_COOLER),
        наличие(ID_SHOP, ID1, PRICE1),
        наличие(ID_SHOP, ID2, PRICE2),
        наличие(ID_SHOP, ID3, PRICE3),
        наличие(ID_SHOP, ID4, PRICE4),
        магазин(ID_SHOP, _, ADDRESS),
        PRICE = PRICE1 + PRICE2 + PRICE3 + PRICE4,
        PRICE < BUDGET,
        write("сборка: \n", MODEL_PROCESSOR, "\n", MODEL_PLATA, "\n", MODEL_VIDEOCARD, "\n", MODEL_COOLER, "\n"),
        write("общая сумма - ", PRICE),
        nl,
        nl,
        fail.

clauses
    run() :-
        consult("../data.txt", db),
        fail.

    % все модели по типу комплектующего
    run() :-
        write("модели процессоров\n"),
        данные_комплектующего("процессор"),
        fail.

    % цены на модель в разных магазинах
    run() :-
        nl,
        nl,
        write("цены на GIGABYTE Z790\n"),
        цены_на_комплектующее("GIGABYTE Z790"),
        fail.

    % все слоты комплектующего
    run() :-
        nl,
        nl,
        write("cлоты видеокарты AMD Radeon RX 7700 - "),
        слоты_комплектующего("AMD Radeon RX 7700"),
        fail.

    % все комплектующие, имеющие определенный слот
    run() :-
        nl,
        nl,
        write("cлот dvi есть в следующих комплектующих:\n"),
        комплектующие_по_слоту(dvi),
        fail.

    % бюджетная сборка
    run() :-
        nl,
        nl,
        write("компьютеры до 60000р:\n\n"),
        бюджетная_сборка(60000),
        fail.

    % игровая сборка в диапазоне цен
    run() :-
        nl,
        nl,
        write("компьютеры в диапазоне 160-170к:\n\n"),
        игровая_сборка(170000),
        fail.

    % собрать компьютер определенного бюджета так, чтобы купить все комплектующие в одном месте
    run() :-
        nl,
        nl,
        write("сборка компьютера в магазине пр. Вернадского, 29:\n\n"),
        сборка_в_магазине("пр. Вернадского, 29", 57000),
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).
