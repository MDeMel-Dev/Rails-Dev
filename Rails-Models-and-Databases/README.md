# Understanding Models and Databases - Rails

- [Understanding Models and Databases - Rails](#understanding-models-and-databases---rails)
    - [What is a database ?](#what-is-a-database-)
    - [Why do we use databases ?](#why-do-we-use-databases-)
    - [What are the databases supported by Rails ?](#what-are-the-databases-supported-by-rails-)
    - [What is a Model and where does it fit into all of this ?](#what-is-a-model-and-where-does-it-fit-into-all-of-this-)
  - [Where do i go from here ? what's the next step ?](#where-do-i-go-from-here--whats-the-next-step-)
    - [First option](#first-option)
    - [Second option](#second-option)
  - [How to populate the database table with rows of data ?](#how-to-populate-the-database-table-with-rows-of-data-)
      - [Why am I getting ' NOT NULL constraint failed ' when migrating with the above code ?](#why-am-i-getting--not-null-constraint-failed--when-migrating-with-the-above-code-)
  - [How to use Models to access and pass the data to be rendered at a given end point ?](#how-to-use-models-to-access-and-pass-the-data-to-be-rendered-at-a-given-end-point-)
    - [Creating index action endpoint to render all jokes](#creating-index-action-endpoint-to-render-all-jokes)
    - [Creating more endpoints to render select jokes](#creating-more-endpoints-to-render-select-jokes)
  - [Model methods cheatsheet (basic)](#model-methods-cheatsheet-basic)

### What is a database ?

A database is a software program that we use to store our data in an organised manner.

### Why do we use databases ?

We use databases to both ' Store ' and ' Access ' data . in context with Rails - Store can be seen as ' Create ' and Access can be broken down further into ' Read ' , ' Delete ' and ' Update '

### What are the databases supported by Rails ?

The following databases are supported in a Rails environment

- SQLite
- MySQL
- PostgreSQL
- DB2
- Firebird 
- FrontBase
- OpenBase
- Oracle
- Microsoft SQL Server
- Sybase

### What is a Model and where does it fit into all of this ?

Not too long ago programs connected to databases directly, and queried (extracted a defined set of data) data using SQL . SQL  stands for ' structured query language ' and is the standard language used to communicate with Relational databases. This is a very low level implementation where we might have to write many lines of SQL code just to extract a few rows of data. (observe the php code below)

```php
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
} 

$sql = "SELECT * FROM Users";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    echo "id: " . $row["id"]. " - Name: " . $row["firstname"]. " " . $row["lastname"]. "<br>";
  }
```

Rails has abstracted away these complicated functions for the most part by implementing a software layer called ' Active Record ' which provides us with domain specific ruby methods that are simple to implement and use - giving us the same results as the aforementioned SQL funtions. 

```ruby
@users = User.all
```

Active record also connects the ' objects ' in our program to tables in our database. **These objects are called ' Models '**. which are derived or ' created ' from Model classes.</br> These classes (class files) are placed in your app/models folder.

## Where do i go from here ? what's the next step ?

There are two patterns when working with your database.

- Create a model and then create a table mapped to that model.

or

- First Create a table then create a model mapped to that table.

Both workflows effectively achieve the same thing utilizing a different set of steps.</br></br>

### First option 
**Let's try using ' rails g model NameOfModel attribute1:type attrribute2:type '**
</br>
- first let's start by creating a new rails application. (m and d)

```
rails new mandd
```

- next let's create a model and the relevant table . add the following to your terminal and execute 

```
rails g model Joke desc:string type:string
``` 
This generates the following set of files..

![railsgm1](railsg1.png)

observe how it creates both a migration file as well as a model class file.
a migration is a ruby file that defines the changes made to your database. (A database was already created for our rails application when we ran the rails new command).

in this case the change that the migration file defines would be to ' create a new jokes table '.</br>
**(Model names are singular while it's corresponding table name will be plural)**. This is what is expected by default and what 'Active Record' will look for when mapping the database table to the relevant model.

Now all of the needed steps are done albeit for one ... (migration)

- running a migration means that we are actually implementing the change that is defined in the migration file. (migration file is just a ' definition ' or a ' record ' of change so it has to be implemented using the following command)

```
rails db:migrate
```
</br>

### Second option 
**We will create the table using migrations as the first step**

```
rails g migration CreateJokes
```

run the above command and we will find..

```ruby
class CreateJokes < ActiveRecord::Migration[6.0]
  def change
  end
end
```
under your db/migrate folder.

let's add the ruby code that will create a 'jokes' table for us

```ruby
class CreateJokes < ActiveRecord::Migration[6.0]
  def change
  create_table :jokes do |jks|
      jks.string :desc
      jks.string :jktype
    end
  end
end
```

The above can also be done using the command...

```
rails g migration CreateJokes desc:string type:string
```

which will not only generate the migrations file for you but also - will include the necessary code in order to create a relevant table.

Rails 'Migrations' is a topic in itself which we will discuss in more depth in a separate session. For the time being if you wish for further reference - you can visit this [link](https://guides.rubyonrails.org/active_record_migrations.html#creating-a-migration) 

- Once the migration file is properly defined we run the following command to execute the migration.

```
rails db:migrate
```

- Now all we need to do is create a relevant model class in order to map to the created 
- create a model class file in your models folder as 'joke.rb'

```ruby
class Joke < ApplicationRecord
end
```

Well done!! you have succefully created a database table and rails model using either of the two options explained above.

A keypoint worth noting is how we extend all model classes with ' ApplicationRecord ' - this is a key aspect to how Active record's ORM mechanism takes place mapping the above class to it's relevant table.


## How to populate the database table with rows of data ?

Some of the ways we can insert data into tables are as follows ,

- To add initial data after a database is created, Rails has a built-in 'seeds' feature. add the necessary code to the db/seeds.rb file... and run - ' **rails db:seed** '

```ruby
jokes = Joke.create([
    
{ desc: 'Did you hear about the mathematician who’s afraid of negative numbers? \nHe’ll stop at nothing to avoid them' , jktype: 'math'}, 
{ desc: 'Why don’t Calculus majors throw house parties? \nBecause you should never drink and derive.' , jktype: 'math'} ])
```

- Create a migrations file with executable sql code under the 'change' method

```ruby
class InsertJokes < ActiveRecord::Migration[6.0]
  def change
  execute "insert into jokes values('Did you hear about the mathematician who’s afraid of negative numbers? \nHe’ll stop at nothing to avoid them.' , 'math'), ('Did you hear about the claustrophobic astronaut? \nHe just needed a little space.' , 'casual'); "
  end
end
```

#### Why am I getting ' NOT NULL constraint failed ' when migrating with the above code ?

This is because of the fields ; 'created_at' and 'updated_at' which are both defined as NOT NULL. these values need to be included if using SQL in conjuction with migrations. When adding rows using ruby these values are automatically generated for us.

- Use 'root' controller class to run a block of code that inserts data using model object.

```ruby
Joke.insert_all(
  [
    {
      desc: "Did you hear about the mathematician who’s afraid of negative numbers? \nHe’ll stop at nothing to avoid them.",
      jktype: "math"
    },
    {
      desc: "Did you hear about the claustrophobic astronaut? \nHe just needed a little space.",
      jktype: "casual"
    }
  ]
)
```


- We can also create a ruby script in .sh and then include the .insert using a model object times the necessary record once gone into the ruby shell.</br>
.............. to be completed .............. </br></br>

- Import data from .csv file and insert to database  ... ([reference](https://dev.to/kputra/rails-bulk-insert-to-db-5hj1#chapter-c)).

```ruby
def import_record
  CSV.read(file_path).each do |record|
     Article.create!(
       title:  record[0],
       author: record[1],
       body:   record[2]
     )
  end
end
```

**For this step let's choose to go with the ' seed method ' which will allow us to insert the records efficiently while also supporting future setups**

## How to use Models to access and pass the data to be rendered at a given end point ?

### Creating index action endpoint to render all jokes

let's add the following code to our routes.rb file

```ruby
root to: "main#home"

  resources :main, only: [:index, :show] do
    collection do
      get 'types'
    end
  end
  ```
  The above code will create the necessary routes for our API
  
  Create a controller class called 'main'

  ```ruby
  class MainController < ApplicationController

    def home
        render inline: "<center><h1> Kiddster API </h1></center>"
    end

    def index
        @jokes = Joke.all
        render json: @jokes
    end

    def show
    end

    def types
    end
end
```

### Creating more endpoints to render select jokes 

Let's add some more features to our controller actions

- show action to show a joke with a specific ID 
- types action to return all available types of jokes
- a ' show_type ' action to return only the requested type

```ruby
class MainController < ApplicationController

    def home
        render inline: "<center><h1> Kiddster API </h1></center>"
    end

    def index
        @jokes = Joke.all
        render json: @jokes
    end

    def show
        render json: Joke.find(params[:id])
    end

    def types
        @jktypes = Joke.select(:jktype)
        render json: @jktypes.map { |jkt| jkt[:jktype] }.uniq 
    end

    def showtype
        @jkts = Joke.where(jktype: params[:jkt])
        render json: @jkts
    end
end
```

Finally add the following route to your routes file for the show type action ( important ! to insert the route above the resourceful routes so that it won't include unintended overheads )

```ruby
get 'main/showtype/:jkt', to: 'main#showtype'
```

Run the rails server and observe what these endpoints bring you.

- http://localhost:3000/main/
- http://localhost:3000/main/5
- http://localhost:3000/main/types
- http://localhost:3000/main/showtype/math


## Model methods cheatsheet (basic)

- CRUD METHODS

```ruby
Model.create(name: 'Nala', haircolor: 'Orange')

Model.all

Model.update(id, attributes)
  # Updating one record:
  Person.update(15, :user_name => 'Samuel', :group => 'expert')

  # Updating multiple records:
  people = { 1 => { "first_name" => "David" }, 2 => { "first_name" => "Jeremy" } }
  Person.update(people.keys, people.values)

Model.destroy
  @record = Model.find(params[:id])
      @record.destroy

Model.delete_all # deletes all records from table
```

- QUERY METHODS

```ruby
Model.where(name: 'anne')
Model.where('id = 3')
Model.where('id = ?', 3)

Model.order(:age)
Model.order(age: :desc)
Model.order("age DESC")

Model.select(:id)
Model.select([:id, :name])
Model.group(:name)   # GROUP BY name
Model.group('name AS grouped_name, age')
Model.having('SUM(awards) > 5')  # needs to be chained with .group

Model.limit(2)
Model.offset(1)
Model.uniq
```

Further reference at this [link](https://devdocs.io/rails~6.1/activerecord/querymethods)

