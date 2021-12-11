/* ЧАСТЬ 1 */

/*
№1
Рассчитать выручку компании в разрезе: Год – Месяц – Выручка компании. Представленные данные отсортировать: Год, Месяц
*/

select
    companyName,
    year(dateId) as "year",
    month(dateId) as "month",
    sum(salesRub) as "sum"
from
    distributor.singleSales
group by
    companyName,
    year(dateId),
    month(dateId)
order by
    year(dateId),
    month(dateId);


/*
№2
Рассчитать выручку компании в разрезе: Дата начало месяца – Выручка компании. Представление данных отсортировать: Дата начало месяца. В чем ключевое отличие от задачи №1? 
*/

select
    companyName,
    year(dateId) as "year",
    month(dateId) as "month",
    sum(salesRub) as "sum"
from
    distributor.singleSales
where
    day(dateId) = 1
group by
    companyName,
    year(dateId),
    month(dateId)
order by
    year(dateId),
    month(dateId);


/*
№3
Для каждой компании рассчитать среднее время между покупками, отдельно показать результат в днях и в месяцах.
*/

with temp(company, mn, mx, num) as (
    select
        companyName,
        min(dateId),
        max(dateId),
        count(distinct checkId)
    from
        distributor.singleSales
    where
        companyName is not null
    group by
        companyName
)
select 
    company,
    (datediff(month, mn, mx) / (num)) as 'months',
    (datediff(day, mn, mx) / (num)) as 'days'
from
    temp
where
    num - 1 != 0
order by
    months desc,
    days desc


/*
№4
Вывести результат задачи №2 только для 2013 года с наложением на столбец «Дата начало месяц» формат месяц. Т. е. я ожидаю увидеть в нем не даты, а январь, февраль, март и т. д.
*/

select
    companyName,
    DateName(
        month,
        DateAdd(
            month,
            month(dateId) - 1,
            '1900-01-01'
        )
    ),
    sum(salesRub) as 'sales'
from
    distributor.singleSales
where
    DAY(dateId) = 1
group by
    companyName,
    month(dateId)
order by
    month(dateId);


/*
№5
Разделить все компании на три сегмента: 
- Очень давно не покупали – не было покупок более 365 дней от текущей даты
- Давно не покупали – не было покупок более 180 дней от текущей даты
- Не покупали – не было покупок более 90 дней от текущей даты
*/ 

declare @start datetime;
set @start = (
    select
        DateAdd(
            year,
            -10,
            getdate()
        )
);
declare @start365 datetime;
set @start365 = (
    select
        DateAdd(
            day,
            -365,
            @start
        )
);
declare @start180 datetime;
set @start180 = (
    select
        DateAdd(
            day,
            -180,
            @start
        )
);
declare @start90 datetime;
set @start90 = (
    select
        DateAdd(
            day,
            -90,
            @start
        )
);
with temp(company, mx) as (
    select
        companyName,
        max(dateId)
    from
        distributor.singleSales
    where
        dateId < @start
    group by
        companyName
)
select top(10)
    company,
    iif(
        (mx < @start365),
        'category 1',
        iif(
            (mx < @start180),
            'category 2',
            iif(
                (mx < @start90),
                'category 3',
                '...'
            )
        )
    ) as 'category'
from
    temp


/*
№6
Рассчитать выручку компании в разрезе: Год – Квартал – Выручка компании. Представленные данные отсортировать: Год, Квартал.
*/

select top(5)
    companyName,
    year(dateId) as 'year',
    datepart(QUARTER, dateId) as 'q',
    sum(salesRub) as 'sales'
from
    distributor.singleSales
group by
    companyName,
    year(dateId),
    datepart(QUARTER, dateId)
order by
    year(dateId),
    datepart(QUARTER, dateId)


/*
№7
Необходимо проверить существование сезонной выручки внутри недели, для этого необходимо рассчитать выручку компании в разрезе:
 Год – День Недели – выручка компании. Представленные данные отсортировать: Год, день недели.
*/

select top(5)
    companyName,
    year(dateId) as 'year',
    datepart(weekday, dateId) as 'day',
    sum(salesRub) as 'sales'
from
    distributor.singleSales
group by
    companyName,
    year(dateId),
    datepart(weekday, dateId)
order by
    year(dateId),
    datepart(weekday, dateId)


/*
№8
Найдите все компании, у которых в наименование есть «ООО», без учета регистра.
*/

select
    companyName
from
    distributor.singleSales
where
    lower(companyName) like '%ооо%'


/*
№9
Найдите все компании, у которых в наименование в начале стоит «ООО», без учета регистра и пробелов вначале.
*/

select
    companyName
from
    distributor.singleSales
where
    lower(companyName) like 'ооо%'


/*
№10
Необходимо разделить ФИ, что записаны в столбеце «fullName» на три столбца, выделив отдельно фамилию, имя и фамилия И. 
*/

select
    distinct fullname,
    substring(
        fullname,
        1,
        charindex(' ', fullname) - 1
    ) as 'surname',
    substring(
        fullname,
        charindex(' ', fullname) + 1,
        len(fullname) - charindex(' ', fullname)
    ) as 'name',
    substring(
        fullname,
        1,
        charindex(' ', fullname) + 1
    ) + '.' as 'surname n.'
from
    distributor.singleSales
where
    fullname is not null







/* ЧАСТЬ 2 */

/*
№1
Рассчитать выручку компании в разрезе: Год – Месяц – Филиал – Выручка компании. Представленные данные отсортировать: Филиал, Год, Месяц.
*/

select top(10
    year(dateId) as 'year',
    month(dateId) as 'month',
    branchName,
    sum(salesRub) as 'sum'
from
    distributor.sales
inner join
    distributor.branch
    ON branch.branchId = sales.branchId
group by
    year(dateId),
    month(dateId),
    branchName
order by
    branchName,
    'year',
    'month'


/*
№2 
Рассчитать выручку компании в разрезе: Филиал - Дата начало месяца – Выручка компании. Представление данных отсортировать: Филиал, Дата начало месяца.
*/

select
    branchId as "Филиал",
    dateId as "Первое число месяца",
    sum(salesRub) as "Выручка"
from
    distributor.sales
where
    day(dateId) = 1
    and branchId is not null
group by
    branchId,
    dateId
order by
    branchId,
    dateId



/*
№3
 Рассчитать выручку компании в разрезе: Филиал – Дата начало месяца – Товарная категория – выручка компании. Представление данных отсортировать: Филиал, Дата начало месяца, Товарная категория.
 */

select
    branchName as "Филиал",
    dateId as "Первое число месяца",
    sum(salesRub) as "Выручка",
    category
from
    distributor.singleSales
where
    day(dateId) = 1
    and branchName is not null
    and Category is not null 
group by
    branchName,
    dateId,
    category
order by
    branchName,
    dateId,
    category


/*
№4
Рассчитать выручку компании в разрезе: Филиал – Дата начало месяца – Бренд – выручка компании. Представление данных отсортировать: Филиал, Дата начало месяца, Бренд.
*/

select 
    branchName as "Филиал",
    dateId as "Первое число месяца",
    sum(salesRub) as "Выручка",
    brand
from
    distributor.singleSales
where
    day(dateId) = 1
    and branchName is not null 
    and brand is not null
group by
    branchName,
    dateId,
    brand
order by
    branchName,
    dateId,
    brand


/*
№5
Написать запрос, сравнивающий общую сумму задачи №4 и Задачи№2. Объяснить расхождения, если они есть. Написать запрос, выявляющий все транзакции влияющие на расхождения выручки в задаче №4.
*/

/*
№6
Определить топ 3 бренда, дающий наибольший вклад в выручку компании за 2013 год.
*/

select distinct top(3)
    brand as "Бренд",
    sum(salesRub) as "Максимальный вклад"
from
    distributor.singleSales
group by
    brand
order by
    sum(salesRub) desc 


/*
№7
Рассчитать выручку компании в разрезе: Менеджер – Бренд – выручка компании. Представленные данные отсортировать: Менеджер, Бренд
*/

select
    fullname as "Менеджер",
    brand as "Бренд",
    sum(salesRub) as "Выручка"
from
    distributor.singleSales
where
    fullname is not null
    and brand is not null
group by
    fullname,
    brand
order by
    fullname,
    brand



/*
№8
Рассчитать кол-во компаний приходятся на менеджера в течение каждого года. Фактически я ожидаю увидеть таблицу: Год – Менеджер – Кол-во компаний.
*/

select
    distinct fullname as "Менеджер",
    year(dateId) as "Год",
    count(companyName) as "Кол-во компаний"
from
    distributor.singleSales
where
    fullname is not null
group by
    dateId,
    fullname,
    companyName


/*
№9
Необходимо разделить ФИ, что записаны в столбеце «fullName» на три столбца, выделив отдельно фамилию, имя и фамилия И. 
*/

select
    year(dateId) as "Год",
    companyName as "Компания",
    (sum(salesRub) - basePricePurchase) as "Выручка"
from
    distributor.sales,
    distributor.ddp
inner join
    distributor.company c
on c.companyId = sales.companyId
where
    companyName is not null
group by
    companyName,
    dateId

/*
№10
Необходимо разделить ФИ, что записаны в столбеце «fullName» на три столбца, выделив отдельно фамилию, имя и фамилия И. 
*/


/*
№11
В таблицу: distributor.remains представлена информация об остатках, как : Филиал – Артикул товара – Дата – Остаток – СвободныйОстаток.
 Особенность заполнения данной таблицы, что если остаток на какую-то дату нулевой (для товара и филиала), то в таблицу он не заноситься, например: 2020-01-01 – 10шт., 2020-01-02 – 7шт. 2020-01-04 – 15 шт. Необходимо, восстановить пропуски в данной таблицы и дописать пропущенные значения. Из нашего примера: 2020-01-03 – 0 шт. Учтите, что даты складирования товара – филиала своя.
*/

select top(10)
    *
from
    distributor.remains
where
    remains = 0


/*
№12
Найти объём неликвидного товара в сравнение со всем товаром в шт. под неликвидом считается товар, который не продавался более 180 дней
*/

declare @start datetime;
set @start = '2014-01-01';

declare @start180 datetime;
set @start180 = (
    select
        DateAdd(
            day,
            -180,
            @start
        )
);

with temp(itemId, mostRecentDateWhenItemWasSold) as (
    select
        itemId,
        max(dateId)
    from
        distributor.sales
    where
        dateId < @start
    group by
        itemId
),
temp2(itemId, liquidity) as (
    select
        itemId,
        iif(
            mostRecentDateWhenItemWasSold < @start180,
            'non liquid',
            'liquid'
        )
    from
        temp
)

select
    count(*) as 'Number of all items',
    (
        select
            count(*)
        from
            temp2
        where
            liquidity = 'non liquid'
    ) as 'Number of non-liquid items'
from
    temp



/*
№13
Определить топ 3 лучших товаров по выручки для каждого Бренда без учета времени, т. е. за всю историю работы компании.
*/

select top(3)
    brand,
    itemName,
    sum(salesRub)
from
    distributor.sales
inner join
    distributor.item
    on (sales.itemId = item.itemId)
group by
    brand,
    itemName
order by
    sum(salesRub) desc


/*
№14
Определить топ 3 лучших товаров по выручке для каждого бренда с учетом временного интервала год.
*/

select top(3)
    brand,
    left(itemName, 40) as 'item',
    sum(salesRub) as 'sum',
    year(dateID) as 'year'
from
    distributor.sales
inner join
    distributor.item
    on (sales.itemId = item.itemId)
group by
    brand,
    itemName,
    year(dateId)
order by
    'sum' desc


/*
№15
Определить долю вклада Топ 3 брендов в выручку компании без учета времени, т. е. за всю историю работы компании.
*/

with temp(brand, brandSales, brandRank) as (
    select
        brand,
        sum(salesRub),
        rank() over (order by sum(salesRub) desc) brandRank
    from
        distributor.sales
    inner join
        distributor.item
        on (sales.itemId = item.itemId)
    where
        companyId = 7322
    group by
        brand
)

select
    sum(brandSales) / (
        select
            sum(brandSales)
        from
            temp
    )
from
    temp
where
    brandRank <= 3


/*
№16
Определить долю вклада Топ 3 брендов в выручку компании без учета времени, т. е. за всю историю работы компании.
*/

with topThreeBrands(year, month, topThreeSum) as (
    select
        temp.year,
        temp.month,
        sum(temp.sum)
    from
        (
            select
                year(dateId) as 'year',
                month(dateId) as 'month',
                brand,
                sum(salesRub) as 'sum',
                row_number() over (
                    partition by
                        year(dateId),
                        month(dateId)
                    order by
                        sum(salesRub) desc
                ) as 'brandRank'
            from
                distributor.sales
            inner join
                distributor.item on (sales.itemId = item.itemId)
            where
                companyId = 7300
            group by
                year(dateId),
                month(dateId),
                brand
        ) as temp
    where
        temp.brandRank <= 3
    group by
        temp.year,
        temp.month
),
allBrands(year, month, allSales) as (
    select
        year(dateId),
        month(dateId),
        sum(salesRub)
    from
        distributor.sales
    inner join
        distributor.item on (sales.itemId = item.itemId)
    where
        companyId = 7322
    group by
        year(dateId),
        month(dateId)
)
select top(10)
    allBrands.year,
    allBrands.month,
    allSales,
    topThreeSum,
    topThreeSum / allSales as ratio
from
    allBrands
inner join
    topThreeBrands on (
        allBrands.year = topThreeBrands.year and
        allBrands.month = topThreeBrands.month
    )
where
    allSales != 0



/*
№19
Вывести среднюю месячную динамику продаж, по выручке за предыдущие три месяца по менеджерам, для периода год – месяц и отдельно «Дата начало месяца».
Т. е. если сейчас 2013-01-01, то я хочу видеть среднюю выручку по менеджерам за 2012-10-01, 2012-11-01,2012-12-01
 */

select top(10)
    s.salesManagerId,
    format(s.dateId, 'MM.yyyy'),
    sum(s.salesRub) as month_revenue
from
    distributor.sales s
inner join
    distributor.salesManager sM
    on s.salesManagerId = sM.salesManagerId
group by
    s.salesManagerId,
    format(s.dateId, 'MM.yyyy')
order by
    s.salesManagerId,
    format(s.dateId, 'MM.yyyy');


/*
№20
Вывести среднюю месячную динамику продаж, по среднему чеку за предыдущие три месяца по менеджерам, для периода год – месяц и отдельно «Дата начало месяца».
Т. е. если сейчас 2013-01-01 то я хочу видеть средний чек по менеджерам за 2012-10-01, 2012-11-01,2012-12-01
*/

with temp as (
    select top(20)
        s.salesManagerId as sm_id,
        format(s.dateId, 'MM.yyyy') as my_date,
        avg(s.salesRub) as month_avg_price
    from
        distributor.sales s
    inner join
        distributor.salesManager sM
        on s.salesManagerId = sM.salesManagerId
    group by
        s.salesManagerId, format(s.dateId, 'MM.yyyy')
    order by
        s.salesManagerId, format(s.dateId, 'MM.yyyy')
)
select
    sm_id,
    my_date,
    month_avg_price,
    avg(month_avg_price) over(
        partition by
            sm_id
        order by
            my_date rows between 3 preceding AND current row
    ) as revenue
from
    temp
group by
    sm_id,
    my_date,
    month_avg_price
order by
    sm_id, my_date,
    month_avg_price


/*
№23
Рассчитать долю загрузки складов для каждого года – месяца.
*/

select
    cast(sum(remains * ai.volume) as float) / sizeBranch as dolya,
    b.branchId
from
    distributor.remains r
inner join
    distributor.branch b
    on r.branchId=b.branchId
inner join
    distributor.attributesItem ai
    on r.itemId=ai.itemId
where
    ai.volume is not null
group by
    year(dateId),
    month(dateId),
    b.branchiD, sizeBranch;


/*
№24
Рассчитайте стоимость складских запасов на основе себестоимости товара на каждом филиале для каждого разреза год – месяц (или дата начало месяца).
Рассчитать так же и на основе альтернативной себестоимости, стоимость складских запасов. (basePrice из таблицы DDP)
*/

select 
    count(itemId),
    count(distinct itemId)
from
    distributor.attributesItem

select top(100)
    *
from
    distributor.ddp


select
    count(*)
    -- d.DDP * ai.boxPacking AS sebestoimost
from
    distributor.attributesItem ai
inner join
    distributor.ddp d
    on d.itemId=ai.itemId
where
    ai.boxPacking is not null
    and d.DDP is not null
-- GROUP BY
--     yearId,
--     monthId,
--     d.DDP,
--     ai.boxPacking

with temp(sebestoimosti)  as (
    select
        d.basePrice * ai.boxPacking as sebestoimost
    from
        distributor.attributesItem ai
    inner join
        distributor.ddp d
        on d.itemId=ai.itemId
    where
        ai.boxPacking is not null
        and d.DDP is not null
    group by
        yearId,
        monthId,
        d.basePrice,
        ai.boxPacking
)
select sum(sebestoimosti) from temp;


/*markdown
№25
Рассчитать коэффициенты месячных сезонностей отдельно по штукам и деньгам для категории: Обои
*/

declare @year_sales as int = (
    select sum(sales)
    from distributor.singleSales ss
    where category=N'Обои'
)
declare @year_sales_rub as int = (
    select sum(salesRub)
    from distributor.singleSales ss
    where category=N'Обои'
)

select
    sum(sales) / @year_sales as month_koef_in_units,
    sum(salesRub) / @year_sales_rub as month_koef_in_rub
from
    distributor.singleSales
where
    category='Обои'
group by
    year(distributor.singleSales.dateId),
    month(distributor.singleSales.dateId);



/*
№27
Рассчитать долю продаж эксклюзивного товара к общему, в разрезе каждого Год-Месяца (или дата начало месяца). Только для категории обои.
*/

with temp1(month, sales) as (
    select
        month(distributor.singleSales.dateId) as month,
        count(distributor.singleSales.itemId)
    from
        distributor.singleSales
    inner join
        distributor.item i
        on singleSales.itemId = i.itemId
    where
        i.exclusive = 'Да' and
        singleSales.category = 'Обои'
    group by
        year(distributor.singleSales.dateId),
        month(distributor.singleSales.dateId)
),
temp2(month, sales) as (
    select
        month(distributor.singleSales.dateId),
        count(distributor.singleSales.itemId)
    from
        distributor.singleSales
    inner join
        distributor.item i
        on singleSales.itemId = i.itemId
    where
        singleSales.category = 'Обои'
    group by
        year(distributor.singleSales.dateId),
        month(distributor.singleSales.dateId)
)
select top(5)
    (cast(temp1.sales as float) / cast(temp2.sales as float)) as ans
from
    temp1
inner join
    temp2
    on temp1.month = temp2.month



