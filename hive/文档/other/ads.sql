--最近1/7/30日	渠道	访客数	统计访问人数
---业务过程: 页面浏览
---访客是mid标识的,一个设备id相当于一个访客
---聚合逻辑:count(distinct mid)
--最近1/7/30日	渠道	会话平均停留时长	统计所有会话平均停留时长
---业务过程: 页面浏览
---聚合逻辑: avg(每个会话的总停留时间)
--最近1/7/30日	渠道	会话平均浏览页面数	统计所有会话平均浏览页面数
---业务过程: 页面浏览
---聚合逻辑: avg(每个会话总页面浏览数)
--最近1/7/30日	渠道	会话总数	统计会话总数
---业务过程: 页面浏览
---聚合逻辑: count(distinct sessionid)
--最近1/7/30日	渠道	跳出率	只有一个页面的会话的比例
---业务过程: 页面浏览
---跳出率: 访问页面总数为1的session个数/总session个数
DROP TABLE IF EXISTS ads_traffic_stats_by_channel;
CREATE EXTERNAL TABLE ads_traffic_stats_by_channel
(
    `dt`               STRING COMMENT '统计日期',
    `recent_days`      BIGINT COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `channel`          STRING COMMENT '渠道',
    `uv_count`         BIGINT COMMENT '访客人数',
    `avg_duration_sec` BIGINT COMMENT '会话平均停留时长，单位为秒',
    `avg_page_count`   BIGINT COMMENT '会话平均浏览页面数',
    `sv_count`         BIGINT COMMENT '会话数',
    `bounce_rate`      DECIMAL(16, 2) COMMENT '跳出率'
) COMMENT '各渠道流量统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_traffic_stats_by_channel/';

--最近1日指标
select
    '2020-06-14',
    1 recent_days,
    channel,
    count(distinct mid_id),
    avg(during_time_1d) / 1000 ,
    avg(page_count_1d),
    count(1),
    sum(if(page_count_1d=1,1,0))/count(1)
from dws_traffic_session_page_view_1d where dt='2020-06-14'
group by channel;

--最近7日
select
    '2020-06-14',
    7 recent_days,
    channel,
    count(distinct mid_id),
    avg(during_time_1d) / 1000 ,
    avg(page_count_1d),
    count(1),
    sum(if(page_count_1d=1,1,0))/count(1)
from dws_traffic_session_page_view_1d where dt<='2020-06-14' and dt>=date_sub('2020-06-14',6)
group by channel;

--最近30日
select
    '2020-06-14',
    30 recent_days,
    channel,
    count(distinct mid_id),
    avg(during_time_1d) / 1000 ,
    avg(page_count_1d),
    count(1),
    sum(if(page_count_1d=1,1,0))/count(1)
from dws_traffic_session_page_view_1d where dt<='2020-06-14' and dt>=date_sub('2020-06-14',29)
group by channel;


---第一种方法:
---问题: 对dws_traffic_session_page_view_1d直接explode的时候,是将整表炸开为3份,数据量后续会比较大,性能比较慢
select
    '2020-06-14',
    recent_days,
    channel,
    count(distinct mid_id),
    avg(during_time_1d) / 1000 ,
    avg(page_count_1d),
    count(1),
    sum(if(page_count_1d=1,1,0))/count(1)
from dws_traffic_session_page_view_1d lateral view explode(array(1,7,30)) tmp as recent_days
where dt<='2020-06-14' and dt>=date_sub('2020-06-14',recent_days-1)
group by channel,recent_days;

--第二种方法
insert overwrite table ads_traffic_stats_by_channel
select * from ads_traffic_stats_by_channel where dt!='2020-06-14'
union
select
    '2020-06-14',
    recent_days,
    channel,
    cast(case recent_days
            when 1 then uv_count_1d
            when 7 then uv_count_7d
            else uv_count_30d
    end  as bigint)uv_count,
    cast(case recent_days
            when 1 then avg_duration_sec_1d
            when 7 then avg_duration_sec_7d
            else avg_duration_sec_30d
    end as bigint)avg_duration_sec,
    cast(case recent_days
            when 1 then avg_page_count_1d
            when 7 then avg_page_count_7d
            else avg_page_count_30d
    end as bigint) avg_page_count,
    cast(case recent_days
            when 1 then sv_count_1d
            when 7 then sv_count_7d
            else sv_count_30d
    end as bigint)sv_count,
    cast(case recent_days
            when 1 then bounce_rate_1d
            when 7 then bounce_rate_7d
            else bounce_rate_30d
    end as decimal(16,2))bounce_rate
from (
         select channel,
                count(distinct if(dt = '2020-06-14', mid_id, null))                                       uv_count_1d,
                avg(if(dt = '2020-06-14', during_time_1d, null)) / 1000                                   avg_duration_sec_1d,
                avg(if(dt = '2020-06-14', page_count_1d, null))                                           avg_page_count_1d,
                sum(if(dt = '2020-06-14', 1, 0))                                                          sv_count_1d,
                sum(if(dt = '2020-06-14' and page_count_1d = 1, 1, 0)) /
                sum(if(dt = '2020-06-14', 1, 0))                                                          bounce_rate_1d,

                count(distinct if(dt >= date_sub('2020-06-14', 6), mid_id, null))                         uv_count_7d,
                avg(if(dt >= date_sub('2020-06-14', 6), during_time_1d, null)) /
                1000                                                                                      avg_duration_sec_7d,
                avg(if(dt >= date_sub('2020-06-14', 6), page_count_1d, null))                             avg_page_count_7d,
                sum(if(dt >= date_sub('2020-06-14', 6), 1, 0))                                            sv_count_7d,
                sum(if(dt >= date_sub('2020-06-14', 6) and page_count_1d = 1, 1, 0)) /
                sum(if(dt >= date_sub('2020-06-14', 6), 1, 0))                                            bounce_rate_7d,

                count(distinct mid_id)                                                                    uv_count_30d,
                avg(during_time_1d) / 1000                                                                avg_duration_sec_30d,
                avg(page_count_1d)                                                                        avg_page_count_30d,
                count(1)                                                                                  sv_count_30d,
                sum(if(page_count_1d = 1, 1, 0)) / count(1)                                               bounce_rate_30d
         from dws_traffic_session_page_view_1d
         where dt <= '2020-06-14'
           and dt >= date_sub('2020-06-14', 29)
         group by channel
     ) t1 lateral view explode(array(1,7,30)) tmp as recent_days;
