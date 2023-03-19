drop database project;
create database project ;

use project;

select * from laptop;

select count(*) from laptop;

-- create a backup 

create table laptop_backup like	 laptop;

insert into laptop_backup select * from laptop;

select * from laptop_backup;

-- check memory consumption for reference

select DATA_LENGTH/1024 from information_schema.tables 
where table_schema = 'project'
and table_name = 'laptop';

select * from laptop;

-- drop unnessecary column

alter table laptop drop column `Unnamed: 0`;

select * from laptop;

-- select * from laptopdata;

-- drop table laptop;

-- create table laptop like laptop_backup;

-- insert into laptop select * from laptop_backup;

-- alter table laptop rename column `Unnamed: 0` to `index`;

-- select * from laptop;

-- alter table laptop drop column `Unnamed: 0`;

-- dealing with missing value

select `index` from laptop
where Company is null and TypeName is null and Inches is null 
and ScreenResolution is null and `Cpu` is null and Ram is null 
and `Memory` is null and Gpu is null and OpSys is null and
Weight is null and Price is null;



delete from laptop where `index` in (
select `index` from laptop
where Company is null and TypeName is null and Inches is null 
and ScreenResolution is null and `Cpu` is null and Ram is null 
and `Memory` is null and Gpu is null and OpSys is null and
Weight is null and Price is null);

select count(*) from laptop ;

-- drop duplicate

-- check 
select Company ,TypeName ,Inches,ScreenResolution ,`Cpu`,Ram,`Memory`,
Gpu,OpSys,Weight,price,count(*) from laptop group by Company ,TypeName ,Inches,
ScreenResolution ,`Cpu`,Ram,`Memory`,Gpu,OpSys,Weight,price having  count(*)>1;


select `index`,Company ,TypeName ,Inches,ScreenResolution ,`Cpu`,Ram,`Memory`,
Gpu,OpSys,Weight,price,min(`index`)from laptop group by Company ,TypeName ,Inches,
ScreenResolution ,`Cpu`,Ram,`Memory`,Gpu,OpSys,Weight,price ;

select min(`index`)from laptop group by Company ,TypeName ,Inches,
ScreenResolution ,`Cpu`,Ram,`Memory`,Gpu,OpSys,Weight,price ;


select * from laptop where `index` not in (select min(`index`)from laptop group by Company ,
TypeName ,Inches,ScreenResolution ,`Cpu`,Ram,`Memory`,Gpu,OpSys,Weight,price);

-- delete duplicate
with base_query as(select min(`index`)from laptop group by Company ,
TypeName ,Inches,ScreenResolution ,`Cpu`,Ram,`Memory`,Gpu,OpSys,Weight,price)
delete from laptop where `index` not in (select * from base_query);

-- check
select Company ,TypeName ,Inches,ScreenResolution ,`Cpu`,Ram,`Memory`,
Gpu,OpSys,Weight,price,count(*) from laptop group by Company ,TypeName ,Inches,
ScreenResolution ,`Cpu`,Ram,`Memory`,Gpu,OpSys,Weight,price having  count(*)>1;

select count(*) from laptop;

-- check for null value 
select distinct Company from laptop;
select distinct TypeName from laptop;
select distinct Company from laptop;

-- changing  Inches to datatype decimal
alter table laptop modify column  Inches Decimal(10,1);


select * from  laptop;


select replace(Ram,'GB','') from laptop;

-- updating Ram column for exampl 9GB to 9
update laptop set Ram = replace(Ram,'GB','') ;

select * from  laptop;

-- changing data type of Ram column to integer
alter table laptop modify column Ram INTEGER;

select DATA_LENGTH/1024 from information_schema.tables 
where table_schema = 'project'
and table_name = 'laptop';

-- Weight
select replace(Weight,'kg','') from laptop;

-- updating Ram column for exampl 1kg to 1
update laptop set Weight = replace(Weight,'kg','') ;

select * from laptop;

-- alter table laptop modify column Weight Decimal(10,2);

delete from laptop where `index` = 209;

alter table laptop modify column Weight Decimal(10,2);

select DATA_LENGTH/1024 from information_schema.tables 
where table_schema = 'project'
and table_name = 'laptop';

delete from laptop where Weight = 0;

-- Price
update laptop set Price = round(Price);

select * from laptop;

alter table laptop modify column Price INTEGER;

select DATA_LENGTH/1024 from information_schema.tables 
where table_schema = 'project'
and table_name = 'laptop';

select * from laptop;

select OpSYS,
case 
	when OpSys like '%mac%' then 'Mac'
    when OpSys like '%windows%' then 'Windows'
    when OpSys like '%Linux%' then 'Linux'
    when OpSys like '%chrome%' then 'Chrome'
    when OpSys like '%android%' then 'Android'
    when OpSys = 'No OS' then 'N/A'
    else 'Other'
    end as 'OS_Brand'
 from laptop;

update laptop set OpSYS = 
case 
	when OpSys like '%mac%' then 'Mac'
    when OpSys like '%windows%' then 'Windows'
    when OpSys like '%Linux%' then 'Linux'
    when OpSys like '%chrome%' then 'Chrome'
    when OpSys like '%android%' then 'Android'
    when OpSys = 'No OS' then 'N/A'
    else 'Other'
end;

select * from laptop;

-- Gpu
alter table laptop 
add column gpu_brand varchar(255) after Gpu,
add column gpu_name varchar(255) after gpu_brand;

select * from laptop;

select Gpu, substring_index(Gpu ,' ',1) from laptop;

update laptop set gpu_brand = substring_index(Gpu ,' ',1);

select * from laptop;

select replace(Gpu , gpu_brand ,'') from laptop;

update laptop set gpu_name = replace(Gpu , gpu_brand ,'');

select * from laptop;

alter table laptop drop column Gpu;

select * from laptop;

-- Cpu

alter table laptop
add column cpu_brand varchar(255) after `Cpu`,
add column cpu_name varchar(255) after cpu_brand,
add column cpu_speed decimal(10,1) after cpu_name;

select * from laptop;

select `Cpu` , substring_index(`Cpu` ," ",1) from laptop;

update laptop set cpu_brand = substring_index(`Cpu` ," ",1);

select * from laptop;

select `Cpu` , substring_index(`Cpu`,' ',-1) from laptop;

select `Cpu` , replace(substring_index(`Cpu`,' ',-1),'GHz',"") from laptop;

select `Cpu` , cast( replace(substring_index(`Cpu`,' ',-1),'GHz',"") 
 as decimal(10,1) ) from laptop;

update laptop 
set cpu_speed = cast( replace(substring_index(`Cpu`,' ',-1),'GHz',"")  as decimal(10,1) );

select * from laptop;

select `Cpu`,
replace(`Cpu`,cpu_brand,''),
substring_index(`Cpu`,' ',-1),
replace(replace(`Cpu`,cpu_brand,''),substring_index(`Cpu`,' ',-1),'')
from laptop;

update laptop 
set cpu_name = replace(replace(`Cpu`,cpu_brand,''),substring_index(`Cpu`,' ',-1),'');

select * from laptop;

alter table laptop drop column `Cpu`;

select * from laptop;

-- Screen Resolution
select ScreenResolution,
substring_index(ScreenResolution," ",-1),
substring_index(substring_index(ScreenResolution," ",-1),"x",1),
substring_index(substring_index(ScreenResolution," ",-1),"x",-1)
from Laptop;

alter table laptop
add column resolution_width integer after ScreenResolution,
add column resolution_height integer after resolution_width;

select * from laptop;

update laptop
set resolution_width = substring_index(substring_index(ScreenResolution," ",-1),"x",1),
resolution_height = substring_index(substring_index(ScreenResolution," ",-1),"x",-1);

select * from laptop;

alter table laptop add column is_touchscreen integer after ScreenResolution;

select * from laptop;

select ScreenResolution , ScreenResolution like '%Touch%' from laptop;

update laptop set is_touchscreen  = ScreenResolution like '%Touch%';

select * from laptop;

alter table laptop add column is_ips_panel integer after ScreenResolution;

select * from laptop;

select ScreenResolution , ScreenResolution like '%IPS%' from laptop;

update laptop set is_ips_panel  = ScreenResolution like '%IPS%';

select * from laptop;

alter table laptop drop column ScreenResolution;

select * from laptop;

select distinct(cpu_name) from laptop;

select substring_index(trim(cpu_name)," ",2) from laptop;

update laptop set cpu_name = substring_index(trim(cpu_name)," ",2);

select distinct(cpu_name) from laptop;

-- Memory


select * from laptop;

alter table laptop add column memory_type varchar(255) after Memory,
add column primary_storage integer after memory_type,
add column secondary_storage integer after primary_storage;

select * from laptop;

select distinct(Memory) from laptop;

select Memory,
case
	when Memory like '%hybrid%' then 'Hybrid'
    when Memory like '%SSD%' and Memory like '%HDD%' then 'Hybrid'
    when Memory like '%Flash Storage%' and Memory like '%HDD%' then 'Hybrid'
    when Memory like '%SSD%' then 'SSD'
    when Memory like '%HDD%' then 'HDD'
    when Memory like '%Flash Storage%' then 'Flash Storage'
    else null
end as 'memory_type'
from laptop;

update laptop set memory_type = case
	when Memory like '%hybrid%' then 'Hybrid'
    when Memory like '%SSD%' and Memory like '%HDD%' then 'Hybrid'
    when Memory like '%Flash Storage%' and Memory like '%HDD%' then 'Hybrid'
    when Memory like '%SSD%' then 'SSD'
    when Memory like '%HDD%' then 'HDD'
    when Memory like '%Flash Storage%' then 'Flash Storage'
    else null
end;

select * from laptop;

select Memory,
regexp_substr(substring_index(Memory,'+',1),'[0-9]+'),
case
 when Memory like '%+%' then  regexp_substr(substring_index(Memory,'+',-1),'[0-9]+')
 else 0 
end
from laptop;

update laptop set
primary_storage = regexp_substr(substring_index(Memory,'+',1),'[0-9]+'),
secondary_storage = case 
						when Memory like '%+%' then
						regexp_substr(substring_index(Memory,'+',-1),'[0-9]+')
                        else 0
                        end;

select * from laptop;

select primary_storage,
case when primary_storage <=3 then primary_storage*1024 else primary_storage end,
secondary_storage,
case when secondary_storage <=3 then secondary_storage*1024 else secondary_storage end
 from laptop;
 
 update laptop set 
 primary_storage = case when primary_storage <=3 then primary_storage*1024 else primary_storage end,
 secondary_storage = case when secondary_storage <=3 then secondary_storage*1024 else secondary_storage end;
 
 select * from laptop;
 
 alter table laptop drop column Memory;
 
 select * from laptop;
 
 alter table laptop drop gpu_name;
 
 select * from laptop;
 
 
 
 





































