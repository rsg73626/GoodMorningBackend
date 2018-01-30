/*
 
 create table if not exists goodmorning_user(
     id serial primary key,
     name varchar(100) not null,
     email varchar(100) not null unique,
     password varchar(100) not null,
     about text,
     photo text
 );
 
create table if not exists contact_type(
    id serial primary key,
    description varchar(50) not null unique
);
 
 insert into contact_type(description) values ('Cellphone'), ('SocialNetwork'), ('Other');

create table if not exists contact(
    id serial primary key,
    content varchar(100) not null,
    type int not null,
    owner int not null,
    foreign key (type) references contact_type (id),
    foreign key (owner) references goodmorning_user (id) on delete cascade
);

create table if not exists greeting_type(
    id serial primary key,
    description varchar(50) not null unique
);
 
 insert into greeting_type(description) values('GoodMorning'),('GoodAfternoon'),('GoodEvening'),('GoodDawn');

 create table if not exists greeting_preference(
     id serial primary key,
     id_user int not null,
     type int not null,
     is_active boolean not null,
     from_time timestamp not null,
     from_string varchar(16),
     foreign key (id_user) references goodmorning_user (id) on delete cascade,
     foreign key (type) references greeting_type (id) on delete cascade,
     unique(id_user, type)
 );
 
create table if not exists greeting(
    id serial primary key,
    type int not null,
    creator int not null,
    message text not null,
    creation_string varchar(10) not null,
    creation_date date not null,
    foreign key (type) references greeting_type (id),
    foreign key (creator) references goodmorning_user (id) on delete cascade
);

create table if not exists interaction(
    id serial primary key,
    greeting int not null,
    receiver int not null,
    is_retributed boolean not null default false,
    is_liked_by_sender boolean not null default false,
    is_liked_by_receiver boolean not null default false,
    foreign key (greeting) references greeting (id),
    foreign key (receiver) references goodmorning_user (id) on delete cascade
);
 
*/
