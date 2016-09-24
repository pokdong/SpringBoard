CREATE SCHEMA book_ex DEFAULT CHARACTER SET utf8;
use book_ex;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

create table tbl_board (d
	bno bigint not null auto_increment,
    title varchar(200) not null,
    content text not null,
    writer varchar(50) not null,
    regdate timestamp not null default now(),
    updatedate timestamp not null,
    modcnt bigint not null default 0,
    viewcnt bigint not null default 0,
    goodcnt bigint not null default 0,
    badcnt bigint not null default 0,
    replycnt bigint not null default 0,
    filescnt bigint not null default 0,
    primary key (bno)
);

#Insert sample
insert into tbl_board(title, content, writer) values ('adminTitle', 'admintContent', 'admin');
insert into tbl_board(title, content, writer) values ('managerTitle', 'managerContent', 'manager');
insert into tbl_board(title, content, writer) values ('userTitle', 'userContent', 'user');

insert into tbl_board(title, content, writer)
(select title, content, writer from tbl_board);



create table tbl_reply (
	rno bigint NOT NULL AUTO_INCREMENT,
    bno bigint NOT NULL default 0,
    replytext varchar(1000) not null,
    replyer varchar(50) not null,
    regdate timestamp not null default now(),
    updatedate timestamp not null,
    modcnt bigint not null default 0,
    goodcnt bigint not null default 0,
    badcnt bigint not null default 0,
    primary key(rno)
);

alter table tbl_reply add constraint fk_board
foreign key (bno) references tbl_board (bno);



create table tbl_attach (
	fullName varchar(150) not null,
    bno bigint not null,
    regdate timestamp default now(),
    primary key(fullName)
);

alter table tbl_attach add constraint fk_board_attach
foreign key (bno) references tbl_board (bno);



CREATE TABLE tbl_user (
	userid VARCHAR(50) NOT NULL,
    userpw VARCHAR(50) NOT NULL,
    username VARCHAR(100) NOT NULL,
    role varchar(50) default 'USER',
    upoint bigint NOT NULL DEFAULT 0,    
    profilepath varchar(100),
    regdate timestamp default now(),
    PRIMARY KEY(userid)
);
