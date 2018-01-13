/*
 
 create table if not exists goodmorning_user(
     id serial primary key,
     name varchar(100) not null,
     about text not null,
     photo text not null,
     email varchar(100) not null unique,
     password varchar(100) not null
 );
 
create table if not exists contact_type(
    id serial primary key,
    description varchar(50) not null unique
);
 
 insert into contact_type(description) values ('Cellphone'), ('SocialNetwork'), ('Other');

create table if not exists contact(
    id serial primary key,
    content varchar(100) not null,
    id_contact_type int not null,
    id_goodmorning_user int not null,
    foreign key (id_contact_type) references contact_type (id),
    foreign key (id_goodmorning_user) references goodmorning_user (id) on delete cascade
);

create table if not exists greeting_type(
    id serial primary key,
    description varchar(50) not null unique
);
 
 insert into greeting_type(description) values('GoodMorning'),('GoodAfternoon'),('GoodEvening'),('GoodDawn');

create table if not exists greeting(
    id serial primary key,
    id_greeting_type int not null,
    id_goodmorning_user int not null,
    message text not null,
    creation date not null,
    foreign key (id_greeting_type) references greeting_type (id),
    foreign key (id_goodmorning_user) references goodmorning_user (id) on delete cascade
);

create table if not exists interaction(
    id serial primary key,
    id_greeting int not null,
    id_receptor_goodmorning_user int not null,
    is_retribuited boolean not null,
    is_liked boolean not null,
    foreign key (id_greeting) references greeting (id),
    foreign key (id_receptor_goodmorning_user) references goodmorning_user (id) on delete cascade
);
 
*/
