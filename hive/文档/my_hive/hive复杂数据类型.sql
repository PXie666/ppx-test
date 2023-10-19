-- hive复杂数据类型

-- 1.只定义一个列，该列中保存整个json字符串
-- 优点：简单
-- 缺点：后续如果需要获取json字符串中的属性值，需结合get_json_object函数处理，会比较麻烦
create table test1(
	line string
);

select 
	get_json_object(line, '$.xq[0]')
	,get_json_object(line, '$.id')
	,get_json_object(line, '$.name')
from test1;

desc function extended get_json_object;

---------------------复杂数据类型-------------------------
array
	类型的定义：array<元素的类型>
	对象的创建：array(元素1,元素2,...)
	select array(1,3,5,7);
	值的获取: 数组对象[角标]
		select array(1,3,5,7)[0]

map
	类型的定义：map<k的类型，v的类型>
	对象的创建：map(k1,v1,k2,v2)
	select map('name','lisi','age',20);
	值的获取:
		1.根据key获取value:map对象['key']
			select map('name','lisi','age',20)['name'];
		2.获取所有 key: map_keys(map)   把map对象传进 map_keys
			select map_keys(map('name','lisi','age',20))		
		3.获取所有 value: map_values(map)   把map对象传进 map_values
			select map_values(map('name','lisi','age',20))
struct -- 一般用 named_struct
	类型的定义：struct<属性名1:类型1,属性名2:类型2,...>
	对象的创建：
		struct(属性值1,属性值2,...)
		select struct('lisi',20);
		==>{"col1":"lisi","col2":20}
		
		named_struct(属性名1,属性值1,属性名2,属性值2,...)
		select named_struct('name','lisi','age',20)
		==>{"name":"lisi","age":20}
	值的获取：
		根据属性名获取属性值: struct对象.属性名
		named_struct('name','lisi','age',20).name

