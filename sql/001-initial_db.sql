

CREATE TABLE domains (
   id int not null AUTO_INCREMENT,
   name varchar(255) not null,
   discovered datetime not null,
   primary key (id),
   unique (name)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE humans (
   id int not null AUTO_INCREMENT,
   domain_id int not null,
   discovered datetime not null,
   checked datetime not null,
   last_seed datetime,
   txt text,
   primary key (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE human_versions (
   id int not null AUTO_INCREMENT,
   domain_id int not null,
   last_seen datetime not null,
   txt text,
   primary key (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE tags (
   id int not null AUTO_INCREMENT,
   name varchar(255),
   primary key (id),
   unique (name)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE domain_tags (
   id int not null AUTO_INCREMENT,
   domain_id int not null,
   tag_id int not null,
   primary key (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE UNIQUE INDEX tag_domain_domain_tags ON domain_tags (tag_id, domain_id);
