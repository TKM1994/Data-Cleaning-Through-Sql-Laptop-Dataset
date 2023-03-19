# Data-Cleaning-Through-Sql-Laptop-Dataset
About Dataset
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
The Uncleaned Laptop Price dataset is a collection of laptop product listings scraped from an online e-commerce website. The dataset includes information about various laptop models, such as their brand, screen size, processor, memory, storage capacity, operating system, and price. However, the dataset is uncleaned, meaning that it contains missing values, inconsistent formatting, and other errors that need to be addressed before the data can be used for analysis or modeling.

The dataset contains both categorical and numerical variables, with the majority of variables being categorical, including brand, model name, screen resolution, processor type, and operating system. Some numerical variables include screen size, memory, and storage capacity. The target variable in the dataset is the price, which is a continuous variable.

The dataset contains over 1,300 laptop listings, making it a reasonably sized dataset for analysis and modeling. The dataset may be useful for machine learning projects related to predicting the price of a laptop based on its specifications. However, before using the dataset, it would be necessary to clean and preprocess the data to address the inconsistencies and missing values.

[Dataset Links](https://www.kaggle.com/datasets/ehtishamsadiq/uncleaned-laptop-price-dataset)


I am going to clean this dataset with mysql queries . Although it is easy to clean dataset with help of python but as most cases in real world data lies within database so it is better to do initial level data level data cleaning  through sql . Here I have used lots of string functions ,DDL and DML commands of mysql

#### steps to do
1. first download dataset from above link or from repository
2. create a database name project
3. import dataset to mysql server through import wizard and name table laptop
4. I shared a sql file in the repository download that and load that script on mysql workbench and you are good to go
5. Else you can go through this markdown file

#### Initial look of data
```sql
    Select * from laptop
```






<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }


</style>

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>index</th>
      <th>Unnamed: 0</th>
      <th>Company</th>
      <th>TypeName</th>
      <th>Inches</th>
      <th>ScreenResolution</th>
      <th>Cpu</th>
      <th>Ram</th>
      <th>Memory</th>
      <th>Gpu</th>
      <th>OpSys</th>
      <th>Weight</th>
      <th>Price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>0</td>
      <td>Apple</td>
      <td>Ultrabook</td>
      <td>13.3</td>
      <td>IPS Panel Retina Display 2560x1600</td>
      <td>Intel Core i5 2.3GHz</td>
      <td>8GB</td>
      <td>128GB SSD</td>
      <td>Intel Iris Plus Graphics 640</td>
      <td>macOS</td>
      <td>1.37kg</td>
      <td>71378.6832</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>1</td>
      <td>Apple</td>
      <td>Ultrabook</td>
      <td>13.3</td>
      <td>1440x900</td>
      <td>Intel Core i5 1.8GHz</td>
      <td>8GB</td>
      <td>128GB Flash Storage</td>
      <td>Intel HD Graphics 6000</td>
      <td>macOS</td>
      <td>1.34kg</td>
      <td>47895.5232</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>2</td>
      <td>HP</td>
      <td>Notebook</td>
      <td>15.6</td>
      <td>Full HD 1920x1080</td>
      <td>Intel Core i5 7200U 2.5GHz</td>
      <td>8GB</td>
      <td>256GB SSD</td>
      <td>Intel HD Graphics 620</td>
      <td>No OS</td>
      <td>1.86kg</td>
      <td>30636.0000</td>
    </tr>
  </tbody>
</table>
</div>



#### count of rows in   dataset
```sql
    select count(*) from laptop
```






<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }


</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>count(*)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1272</td>
    </tr>
  </tbody>
</table>
</div>



#### Let's create a backup data
```sql
    create table laptop_backup like	 laptop;
    insert into laptop_backup select * from laptop;

```

#### count of rows in  backup dataset
```sql
    select count(*) from laptop_backup
```

#### check for space occupied
```sql
                    select DATA_LENGTH/1024 from information_schema.tables 
                    where table_schema = 'project'
                    and table_name = 'laptop';
```






<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }


</style>

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>DATA_LENGTH/1024</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>256.0</td>
    </tr>
  </tbody>
</table>
</div>



#### drop unnecessary column
```sql
     alter table laptop drop column `Unnamed: 0`;
     Select * from laptop;
```

#### check for null rows
```sql
        select `index` from laptop
        where Company is null and TypeName is null and Inches is null 
        and ScreenResolution is null and `Cpu` is null and Ram is null 
        and `Memory` is null and Gpu is null and OpSys is null and
        Weight is null and Price is null;
```

#### delete all the null row
```sql
        delete from laptop where `index` in (
        select `index` from laptop
        where Company is null and TypeName is null and Inches is null 
        and ScreenResolution is null and `Cpu` is null and Ram is null 
        and `Memory` is null and Gpu is null and OpSys is null and
        Weight is null and Price is null)
```

#### check for duplicate row
``` sql

    select Company ,TypeName ,Inches,ScreenResolution ,`Cpu`,Ram,`Memory`,
    Gpu,OpSys,Weight,price,count(*) from laptop group by Company ,TypeName ,Inches,
    ScreenResolution ,`Cpu`,Ram,`Memory`,Gpu,OpSys,Weight,price having  count(*)>1;

```

#### delete duplicate row
``` sql
    with base_query as(select min(`index`)from laptopdata group by Company ,
                        TypeName ,Inches,ScreenResolution ,
                        `Cpu`,Ram,`Memory`,Gpu,OpSys,Weight,price)
    delete from laptop where `index` not in (select * from base_query);
```
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }


</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>count(*)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1243</td>
    </tr>
  </tbody>
</table>
</div>



## Inches Column
##### changing Inches to datatpe to decimal
```sql
    alter table laptop modify column  Inches Decimal(10,1);
```

## Ram Column
##### removing GB
```sql
    update laptop set Ram = replace(Ram,'GB','') ;
```

#### Changing data type of Ram column to integer
```sql
    alter table laptop modify column Ram INTEGER;
```

## Weight Column
#### removing kg
```sql
   update laptop set Weight = replace(Weight,'kg','') ;
```

### changing data type of Weight column to decimal
```sql
       alter table laptop modify column Weight Decimal(10,2);
```

### delete record where weight is 0
```sql
       delete from laptop where Weight = 0;
```

### Price
###### rounding of price
```sql
    update laptop set Price = round(Price);
```

##### changing price column datatype to integer
```sql
    alter table laptop modify column Price INTEGER;
```

### OpSYS
###### changing OpSYS values 
###### there are values like windows 10,windows11,windows 7 ....,we are going to convert all to windows similarly to other
``` sql
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
```

## Gpu
##### strategy is to extract Brand name from Gpu column and drop the Gpu column
```sql
alter table laptop 
add column gpu_brand varchar(255) after Gpu;


update laptop set gpu_brand = substring_index(Gpu ,' ',1);


alter table laptop drop column Gpu;

```

## Cpu
##### strategy is to make make three new column name cpu_brand,cpu_speed,cpu_name from cpu and finaly drop cpu column . also in cpu speed column I am going to remove GHz and convert that column to decimal
```sql
    alter table laptop
    add column cpu_brand varchar(255) after `Cpu`,
    add column cpu_name varchar(255) after cpu_brand,
    add column cpu_speed decimal(10,1) after cpu_name; 
    
    update laptop set cpu_brand = substring_index(`Cpu` ," ",1);
    
    update laptop 
    set cpu_speed = cast( replace(substring_index(`Cpu`,' ',-1),'GHz',"")  as decimal(10,1) );
    
    update laptop 
    set cpu_name = replace(replace(`Cpu`,cpu_brand,''),substring_index(`Cpu`,' ',-1),'');
    
    update laptop
    set cpu_name = substring_index(trim(cpu_name)," ",2);
    
    alter table laptop drop column `Cpu`;

```


## Screen Resolution
#### strategy is to add four column name resolution_width , resolution_height ,is_touchscreen,is_ips_panel and drop ScreenResolution 
```sql
    alter table laptop
    add column resolution_width integer after ScreenResolution,
    add column resolution_height integer after resolution_width,
    add column is_touchscreen integer after resolution_height,
    add column is_ips_panel integer after is_touchscreen;
    
    update laptop
    set resolution_width = substring_index(substring_index(ScreenResolution," ",-1),"x",1),
    resolution_height = substring_index(substring_index(ScreenResolution," ",-1),"x",-1),
    is_touchscreen  = ScreenResolution like '%Touch%',
    is_ips_panel  = ScreenResolution like '%IPS%';

    alter table laptop drop column ScreenResolution;

```


## Memory
##### strategy is to make three new column name memory_type , primary_storage, secondary storage also all the memoryis going to be in Gb
```sql
    alter table laptop 
    add column memory_type varchar(255) after Memory,
    add column primary_storage integer after memory_type,
    add column secondary_storage integer after primary_storage;
    
    
    update laptop
    set memory_type =
    case
        when Memory like '%hybrid%' then 'Hybrid'
        when Memory like '%SSD%' and Memory like '%HDD%' then 'Hybrid'
        when Memory like '%Flash Storage%' and Memory like '%HDD%' then 'Hybrid'
        when Memory like '%SSD%' then 'SSD'
        when Memory like '%HDD%' then 'HDD'
        when Memory like '%Flash Storage%' then 'Flash Storage'
        else null
    end;
    
    update laptop set
    primary_storage = regexp_substr(substring_index(Memory,'+',1),'[0-9]+');
    
    update laptop set
    secondary_storage = 
    case 
		when Memory like '%+%' then regexp_substr(substring_index(Memory,'+',-1),'[0-9]+')
        else 0
    end;
    
    
    
    update laptop set 
     primary_storage = 
     case 
         when primary_storage <=3 then primary_storage*1024
         else primary_storage 
     end,
     
     secondary_storage = 
     case 
          when secondary_storage <=3 then secondary_storage*1024
          else secondary_storage
     end;
     
     
     alter table laptop drop column Memory;

```

```sql
    Select * from laptop
```


<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }


</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>index</th>
      <th>Company</th>
      <th>TypeName</th>
      <th>Inches</th>
      <th>is_ips_panel</th>
      <th>is_touchscreen</th>
      <th>resolution_width</th>
      <th>resolution_height</th>
      <th>cpu_brand</th>
      <th>cpu_name</th>
      <th>cpu_speed</th>
      <th>Ram</th>
      <th>memory_type</th>
      <th>primary_storage</th>
      <th>secondary_storage</th>
      <th>gpu_brand</th>
      <th>OpSys</th>
      <th>Weight</th>
      <th>Price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>Apple</td>
      <td>Ultrabook</td>
      <td>13.3</td>
      <td>1</td>
      <td>0</td>
      <td>2560</td>
      <td>1600</td>
      <td>Intel</td>
      <td>Core i5</td>
      <td>2.3</td>
      <td>8</td>
      <td>SSD</td>
      <td>128.0</td>
      <td>0</td>
      <td>Intel</td>
      <td>Mac</td>
      <td>1.37</td>
      <td>71379</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>Apple</td>
      <td>Ultrabook</td>
      <td>13.3</td>
      <td>0</td>
      <td>0</td>
      <td>1440</td>
      <td>900</td>
      <td>Intel</td>
      <td>Core i5</td>
      <td>1.8</td>
      <td>8</td>
      <td>Flash Storage</td>
      <td>128.0</td>
      <td>0</td>
      <td>Intel</td>
      <td>Mac</td>
      <td>1.34</td>
      <td>47896</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>HP</td>
      <td>Notebook</td>
      <td>15.6</td>
      <td>0</td>
      <td>0</td>
      <td>1920</td>
      <td>1080</td>
      <td>Intel</td>
      <td>Core i5</td>
      <td>2.5</td>
      <td>8</td>
      <td>SSD</td>
      <td>256.0</td>
      <td>0</td>
      <td>Intel</td>
      <td>N/A</td>
      <td>1.86</td>
      <td>30636</td>
    </tr>
  </tbody>
</table>
</div>

