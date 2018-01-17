import StORM
import PostgresStORM

class ConfigDB {
    
    //MARK: SetUp functions
    static func connect(host: String, username: String, password: String, database: String, port: Int){
        print("Connection to database \(database)...")
        PostgresConnector.host = host
        PostgresConnector.username = username
        PostgresConnector.password = password
        PostgresConnector.database = database
        PostgresConnector.port = port
        print("Connected to database \(database).")
    }
    
    static func createTables(){
        print("Creating tables...")
        createUserTable()
        createContactTable()
        createGreetingTable()
        createInteractionTable()
        print("Tables created.")
    }
    
    static func runSeeds(){
        print("Running seeds...")
        UserSeed.createDevelopmentSeeds()
        print("Seeds created.")
    }
    
    //MARK: create table functions
    private static func createUserTable(){
        let user: User = User()
        try? user.setup("create table if not exists goodmorning_user(id serial primary key,name varchar(100) not null,email varchar(100) not null unique,password varchar(100) not null,about text,photo text);")
    }
    
    private static func createContactTable(){
        let contact: Contact = Contact()
        try? contact.setup("create table if not exists contact_type(id serial primary key,description varchar(50) not null unique);")
        try? contact.setup("insert into contact_type(description) values ('Cellphone'), ('SocialNetwork'), ('Other');")
        try? contact.setup("create table if not exists contact(id serial primary key,content varchar(100) not null,type int not null,owner int not null,foreign key (type) references contact_type (id),foreign key (owner) references goodmorning_user (id) on delete cascade);")
    }
    
    private static func createGreetingTable(){
        let greeting: Greeting = Greeting()
        try? greeting.setup("create table if not exists greeting_type(id serial primary key,description varchar(50) not null unique);")
        try? greeting.setup("insert into greeting_type(description) values('GoodMorning'),('GoodAfternoon'),('GoodEvening'),('GoodDawn');")
        try? greeting.setup("create table if not exists greeting(id serial primary key,type int not null,creator int not null,message text not null,creation_string varchar(10) not null,creation_date date not null,foreign key (type) references greeting_type (id),foreign key (creator) references goodmorning_user (id) on delete cascade);")
    }
    
    private static func createInteractionTable(){
        let interaction: Interaction = Interaction()
        try? interaction.setup("create table if not exists interaction(id serial primary key,greeting int not null,receiver int not null,is_retributed boolean not null default false,is_liked_by_sender boolean not null default false,is_liked_by_receiver boolean not null default false,foreign key (greeting) references greeting (id),foreign key (receiver) references goodmorning_user (id) on delete cascade);")
    }
}
    

