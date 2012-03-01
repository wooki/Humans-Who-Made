alter database humans charset=utf8;

alter table domains charset=utf8;
alter table domains MODIFY name varchar(255) character set utf8 not null;
alter table domains MODIFY title varchar(255) character set utf8 not null;
alter table domains MODIFY description varchar(255) character set utf8 not null;

alter table humans charset=utf8;
alter table humans MODIFY txt text character set utf8;

alter table human_versions charset=utf8;
alter table human_versions MODIFY txt text character set utf8;

alter table tags charset=utf8;
alter table tags MODIFY name varchar(255) character set utf8 not null;

