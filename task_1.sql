/*
№2
Вывести следующею информацию из таблицы: «_2.2 Продажи»: 
Менеджер, Сумма продажи, кол-во продаж, контрагент, 
артикул товара со следующими отборами:
*/

select top(10)
    SalesRub,
    Sales,
    fullname,
    itemId
from 
    distributor.singleSales
where
    fullname is not null

/*
№3
На основе прошлых информации найти транзакции со следующей информацией:
*/

/* минимальные продажи / максимальные продажи */
select
    min(salesRub) as "min sale sum",
    max(salesRub) as "max sale sum"
from
    distributor.singleSales

/* минимальное кол-во продаж / максимальное кол-во продаж */
select
    min(sales) as "min sale",
    max(sales) as "max sale" 
from
    distributor.singleSales


/*
№4
Найти лучшего менеджера по продажам в филиале за определенный месяц (у меня это март)
*/

select distinct top(1)
    fullname as "best manager of the month"
from 
    distributor.singleSales
where
    sales = (
        select
            max(sales) as max_sales
        from
            distributor.singleSales
        where 
            month(dateId) = 3
    ) and
    fullname is not null;


/*
№5
Рассчитать кол-во уникальных чеков
*/

select
    count(distinct checkId) as "unique checks quantity"
from 
    distributor.singleSales


/*
№6
Рассчитать кол-во уникальных чеков с суммой продажи более 10 000 рублей
*/

select
    count(distinct checkId) as "unique checks quantity with sum > 10 000 rubles"
from 
    distributor.singleSales
where
    SalesRub > 10000


/*
№7
Найти чек с максимальным количеством уникальных позиций
*/

select top(1)
    checkId,
    count(distinct itemId) as quantity
from
    distributor.singleSales
where 
    checkId is not null
group by 
    checkId
order by
    quantity desc


/*
№8
Отсортировать данные по убыванию продаж в транзакциях, со следующими условиями:
- дата между 2011-01-01 и 2011-01-30
- категория Обои
- название товара не пропущено
*/

select
    *
from
    distributor.singleSales
where 
    dateId between '2011-01-01' and '2011-01-30'
    and itemName is not null
    and category = 'Обои'
order by
    SalesRub desc


/*
№9
Отсортировать данные по убыванию продаж в чеках, со следующими условиями
- дата между 2011-01-01 и 2011-01-30
- категория Обои
- название товара не пропущено
- название компании не пропущено
- имя манагера не пропущено
*/

select
    *
from
    distributor.singleSales
where 
    dateId between '2011-01-01' and '2011-01-30'
    and itemName is not null
    and companyName is not null
    and fullname is not null
    and category = 'Обои'
order by
    sales desc


/*
№10
Отсортировать по возрастанию по менеджерам, внутри следующего запроса
*/

select
    *
from
    distributor.singleSales
where 
    dateId between '2011-01-01' and '2011-01-30'
    and itemName is not null
    and companyName is not null
    and fullname is not null
    and category = 'Обои'
order by
    fullname


/*
№11
Отсортировать по возрастанию менеджеров и
по убыванию продаж транзакций внутри менеджеров по следующим условиями
*/

select
    *
from
    distributor.singleSales
where 
    dateId between '2011-01-01' and '2011-01-30'
    and itemName is not null
    and companyName is not null
    and fullname is not null
    and category = 'Обои'
order by
    fullname asc, 
    SalesRub desc


/*
№12
Получить информацию о транзакции с максимальной суммой платежа со следующими условиями
*/

select top(1)
    *
from 
    distributor.singleSales
where 
    salesRub = (
        select
            max(SalesRub)
        from 
            distributor.singleSales
    )


/*
№13
Получить информацию о № чека с максимальной суммой платежа, по следующим условиям
*/

select top(1)
    checkId
from 
    distributor.singleSales 
where 
    salesRub = (
        select
            max(SalesRub)
        from 
            distributor.singleSales
    )


/*
№14
Переименовать красиво все наименования столбцов при вызове таблицы со следующими условиями
- название компании содержит "бе"
- менеджер не пуст
*/

select top(10)
    checkId as "Номер чека",
    itemId as "Инд. номер товара",
    branchName as "Город",
    region as "Регион",
    sizeBranch as "Размер склада",
    fullname as "Менеджер",
    companyName as "Компания",
    itemName as "Наименование товара",
    brand as "Брэнд",
    category as "Категория",
    dateId as "Дата",
    sales as "Количество продаж",
    salesRub as "Сумма продаж"
from
    distributor.singleSales

where
    companyName like '%бе%' 
    and fullname is not null


/*
№15
Посчитать количество уникальных менеджеров со следующими условиями
- название компании не пусто
- сумма транзакции < 100
*/

select 
    count(distinct fullname) as quantity
from 
    distributor.singleSales
where 
    companyName is not null
    and SalesRub < 100


/*
№16
Посчитать кол-во уникальных клиентов со следующими условиями
- Даты покупок с 01.04.2011
- Покупок больше 3
- Название компании начинается с “ООО”
*/

select
    count(distinct companyName) as quantity
from
    distributor.singleSales
where
    sales > 3
    and companyName like 'ООО%'
    and dateId > '2011-04-01'


/*
№17
Сколько обслуживает клиентов каждый менеджер со следующими условиями
- название компании начинается с ООО
- фио менеджера не пропущено
*/

select 
    fullname,
    count (distinct companyName)
from 
    distributor.singleSales
where
    companyName like 'ООО%'
    and fullname is not null
group by
    fullname


/*
№18
18.	Сколько в среднем обслуживает клиентов менеджер филиала
*/

select
    branchName,
    count(distinct companyName) / 
    count(distinct fullname) as "avg кол-во клиентов на менеджера филиала"
from
    distributor.singleSales
where
    fullname is not null
group by
    branchName


/*
№19
Сколько всего клиентов обслужил филиала, за определенный период
*/

select 
    branchName, 
    count(distinct companyName) as "количество обслуживаемых клиентов"
from 
    distributor.singleSales
where
     dateId between '2011-01-01' and '2011-01-30'
group by
    branchName


/*
№20
Какой менеджер обслужил в филиале, максимальное кол-во клиентов
*/

select distinct top(3)
    fullname,
    count(distinct CheckId) as clientNumbers
from 
    distributor.singleSales
where
    branchName = 'Екатеринбург'
    and dateId between '2011-01-01' and '2011-01-30'
group by 
    fullname
order by 
clientNumbers desc;


/*
№21
Какой менеджер, принес максимальную выручку в филиале за определенный месяц
*/

select distinct top(3)
    fullname,
    sum(SalesRub) as sumOfSales
from 
    distributor.singleSales
where
    branchName = 'Екатеринбург'
    and dateId between '2011-01-01' and '2011-01-30'
group by 
    fullname
order by 
sumOfSales desc;


/*
№22
Рассчитать средний чек клиенту по выбранному менеджеру
*/

select
sum(SalesRub) / count(distinct CheckId) as avgSales
from distributor.singleSales
where fullname = 'Наумов Сергей'


/*
№23
Рассчитать средний чек клиента по филиалу
*/

select
    branchName,
    sum(SalesRub) / count(distinct CheckId) as avgSales
from 
    distributor.singleSales
group by
    branchName


/*
№24
Рассчитать средний чек клиента по менеджерам внутри филиала
*/

select
    branchName,
    fullname,
    sum(SalesRub) / count(distinct CheckId) as avgSales
from 
    distributor.singleSales
group by
    branchName, 
    fullname


/*
№25
Найти с помощью неточного поиска, следующие наименования компании
- ИП 
- ООО
*/

select
    companyName
from
    distributor.company
where
    (companyName like 'ООО%'
    or companyName like 'ИП%')
    and DateId between '2011-03-01' and '2011-04-01'


/*
№26
Из задачи прошлого найти средний чек, который он оставляет в компании
*/

select
    companyName,
    sum(SalesRub) / count(distinct CheckId) as avgSales
from
     distributor.singleSales
where
    (companyName like 'ООО%'
    or companyName like 'ИП%')
    and DateId between '2011-03-01' and '2011-04-01'
group by
    companyName


/*
№27
Рассчитать АВС товарных позиций ( задача со звездочкой)
*/


/*
№28
Рассчитать среднее кол-во артикулов в чеке, по следующим условиями
*/

select
    avg(total) as average
from
    (
        select
            COUNT(itemId) as total,
            checkId
        from
            distributor.singleSales
        group by
            checkId
    ) as s

/*
№29
Рассчитать среднее кол-во артикулов в чеке, в разрезе выделенного менеджера, по следующим условиями
*/

select
    a.fullname,
    avg(n) as average
from
    (
        select
            count(itemId) as n,
            checkId,
            fullname
        from
            distributor.singleSales
        where
            fullname is not null and
            salesRub < 3000 and
            companyName is not null
        group by 
            checkId,
            fullname
    ) as a
group by
    a.fullname
order by
    a.fullname


/*
№30
Найти всех менеджеров, которые продали более 2 млн. рублей, со следующими условиями
*/

select
    a.fullname
from
    (
        select   
            fullname,
            sum(salesRub) as salesSum
        from
            distributor.singleSales
        group by
            fullname  
    ) as a 
where
    a.salesSum > 2000000
    and a.fullname is not null


/*
№31
Найти всех менеджеров, которые продают более 50 клиентам, со следующими условиями
*/

select
    fullname,
    count(companyName) as companyCount
from
    distributor.singleSales
group by
    fullname
having
    count(companyName) > 50
    and fullname is not null


/*
№32
Есть менеджеры, которые продают в более чем одном филиале, найти их!
*/

select
    distinct fullname,
    count(distinct branchName) as cnt
from
    distributor.singleSales
where
    fullname is not null
group by
    fullname
having 
    count(distinct branchName) > 1
order by cnt desc;


/*
№33
Найти сумму продаж по менеджерам, со следующими условиями
*/

select
    distinct fullname,
    floor(sum(salesRub * sales)) AS summ
from
    distributor.singleSales
group by
    fullname
having
    fullname is not null


/*
№35
Показать, что среднее кол-во чеков и среднее по транзакции это разные вещи.
*/

select
    count(distinct checkId) as n
from
    distributor.singleSales

select
    count(itemId)
from
    distributor.singleSales



select
    avg(n) as average
from
    (
        select
            avg(DISTINCT checkId) AS n
        FROM
            distributor.singleSales
    ) AS s;

SELECT
    COUNT(itemId) AS avgTxn
FROM
    distributor.singleSales


/*
№36
Найти количество уникальных счетов при условиях.
*/

select
    count(distinct account) as accounts
from
    (
        select
            checkId,
            sum(sales * salesRub) as account
        from
            distributor.singleSales
        group by
            checkId
        having
            count(sales) > 2
    ) as s
