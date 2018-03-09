create database wavesrssi;
use mysql;
CREATE USER 'wavesrssi'@'localhost' IDENTIFIED BY 'wavesrssi';
CREATE USER 'wavesrssi'@'%' IDENTIFIED BY 'wavesrssi';
insert into db (host,Db,User) values("localhost","wavesrssi","wavesrssi");
insert into db (host,Db,User) values("%","wavesrssi","wavesrssi");

update db set 
Select_priv = "Y", 
Insert_priv = "Y", 
Update_priv = "Y", 
Delete_priv = "Y", 
Index_priv  = "Y", 
Execute_priv  = "Y", 
Create_view_priv = "Y", 
Show_view_priv = "Y" 
where user = "wavesrssi" AND host="localhost";

update db set 
Select_priv = "Y", 
Insert_priv = "Y", 
Update_priv = "Y", 
Delete_priv = "Y", 
Index_priv  = "Y", 
Execute_priv  = "Y", 
Create_view_priv = "Y", 
Show_view_priv = "Y" 
where user = "wavesrssi" AND host="%";

flush privileges;



use wavesrssi;
create table wavesrssi ( 
id int(16) NOT NULL AUTO_INCREMENT,
KEY (id), 
updated TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), 
node VARCHAR(20), 
radio VARCHAR(10), 
mcs int(3) DEFAULT 0, 
rssi int(3) DEFAULT 0, 
lqi int(3) DEFAULT 0 
);


CREATE UNIQUE INDEX updated USING HASH ON wavesrssi (updated,id);


