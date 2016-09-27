CREATE SCHEMA book_ex DEFAULT CHARACTER SET utf8;
use book_ex;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

create table tbl_board (
	bno bigint not null auto_increment,
    title varchar(200) not null,
    content longtext not null,
    writer varchar(50) not null,
    regdate datetime not null default now(),
    updatedate datetime NOT NULL default '1970-01-01 00:00:01',
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
    regdate datetime not null default now(),
    updatedate datetime NOT NULL default '1970-01-01 00:00:01',
    modcnt bigint not null default 0,
    goodcnt bigint not null default 0,
    badcnt bigint not null default 0,
    primary key(rno)
);

alter table tbl_reply add constraint fk_board
foreign key (bno) references tbl_board (bno);


#Insert sample
INSERT INTO tbl_reply (BNO, REPLYTEXT, REPLYER)
VALUES (1, 'test', 'admin');

INSERT INTO tbl_reply (BNO, REPLYTEXT, REPLYER)
VALUES (1, 'MANAGER!', 'manager');

INSERT INTO tbl_reply (BNO, REPLYTEXT, REPLYER)
VALUES (1, 'U S E R ★', 'user');

insert into tbl_reply(bno, replytext, replyer)
(select bno, replytext, replyer from tbl_reply);

UPDATE tbl_board
SET REPLYCNT =
(
	SELECT COUNT(RNO)
	FROM tbl_reply
	WHERE BNO = tbl_board.BNO
)
WHERE BNO > 0;




create table tbl_attach (
	fullName varchar(150) not null,
    bno bigint not null,
    regdate datetime default now(),
    primary key(fullName)
);

alter table tbl_attach add constraint fk_board_attach
foreign key (bno) references tbl_board (bno);



CREATE TABLE tbl_user (
	userid VARCHAR(50) NOT NULL,
    userpw longtext NOT NULL,
    username VARCHAR(100) NOT NULL,
    role varchar(50) NOT NULL default 'USER',
    upoint bigint NOT NULL DEFAULT 0,    
    profilepath varchar(100),
    regdate datetime default now(),    
    deactive tinyint NOT NULL default 0,
    deactivedate datetime NOT NULL default '1970-01-01 00:00:01',
    withdrawal tinyint NOT NULL default 0,    
    PRIMARY KEY(userid)
);