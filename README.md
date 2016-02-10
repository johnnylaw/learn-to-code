### Adding quotes to the app
There are many ways to go about this. You may have heard of Rails scaffolding, for instance. That would create us a framework for doing all basic CRUD operations on the quotes. Today, though, we wanna focus on each of the five layers of the web request that are in our control (all but the browser) to learn a bit more in-depth about what's happening. If you want to see how blistering quickly one can add this kind of functionality to an app, it may be fun to watch [The world famous DHH demo from 2005](https://www.youtube.com/watch?v=Gzj723LkRJY). WARNING: Rails has changed a lot since then, so following along won't be easy!

#### Creating a "Quote" model (and database table)
```bash
$ rails generate model Quote body:text author:string year:integer verified:boolean # Remember we can type simply "rails generate model" to get help with available field types.
```
Notice if we try to refresh the browser now, we get an error that tells us that we have pending migrations. This means that the model generator made a file with instructions to add a "quotes" table to the database. We want to "run" this migration to actually add the table to the database, and we do so by typing on the command line:
```bash
$ rake db:migrate
```
We have just created a place to store new quotes! Next we're going to create a way to field the incoming requests that concern quotes (e.g. to create them or show them). Because we are moving fast here tonight and we want to get feedback right away about how we're doing, we will start by doing what's called "seeding" the database. Open up the file at ```db/seeds.rb``` and place the following inside of it (Hint for second exercise):
```ruby
Quote.create(
  body: "Health nuts are going to feel stupid one day, lying around in hospitals dying of nothing.",
  author: "Redd Foxx",
  year: nil,
  verified: true
)
Quote.create(
  body: "Wherever you go, there you are.",
  author: "Buckaroo Bonzai",
  year: 1997,
  verified: false
)
puts "Count of quotes in the database: #{Quote.count}"
puts "Attributes of first quote in the database:\n#{Quote.first.attributes}"
```
Then from a command line:
```bash
$ rake db:seed
```
Now we'll see some output that let's us know that we have at least one quote in the database, something to see when we start making our controllers and views.

#### Creating routing for the new "quotes" pages
We want to create a set of routes to tell the router that we want to be able to have quotes on our application. First let's see what routes we already have. Rails has a tool to help with that, and we can check that out by typing the following from a command line:
```bash
$ rake routes
```
Notice the application has a route already. We don't need to worry about that right now; it's there to help us see something at the homepage. Now open the file in the location ```./config/routes.rb``` and add the following line:
```ruby
  resources :quotes # Notice that both the word "resources" and the symbol :quotes are pluralized. This is important!
```
Go back to the command line and type ```rake routes``` again. Notice what changed! When we put that line of code in routes.rb, we told Rails that we want a full set of routes to use for Creating, Reading, Updating and Deleting "quotes". In this exercise, we will only take advantage of a couple of these routes, but many of them would eventually be useful if we were making a fully functioning application.

So now we should be able to visit these pages by typing in the URL, right? Let's try by putting ```http://localhost:3000/quotes``` into the address bar. The error tells us there is no controller. The router has tried to send us to the QuotesController, but there isn't one. Let's fix this.

#### Creating a "Quotes" controller (and view)
```bash
$ rails generate controller Quotes
```
Notice Rails tells us all the files it's generating. We won't cover most of these now, but we are certainly happy to see the file called ```app/controllers/quotes_controller.rb``` (That's our controller!) and the directory at ```app/views/quotes``` (That's where our views will go.). Let's go hit refresh in the browser. Notice a new error? We have not defined an 'index' action. What is that? It's a method (think function) inside the Quotes Controller called 'index'. We can define that to get rid of this error. Open the file at ```./app/controllers/quotes_controller.rb``` and add:
```ruby
def index
end
```
Now let's refresh again. Now we get a rather complicated-looking error, but it is telling us that there is no template file. By template, Rails is referring to a view. If you parse the error message carefully you will be able to see that it is trying to find a file in a particular place, namely in the ```app/views/quotes``` directory. The file it's looking for there has the same name as the action, namely 'index', and it expects the file to have one of several extensions (We'll use .html.erb). Notice that the directory is named after the controller! If we don't tell Rails any different, it will always think this way. Since there's no view file, we need to make one. From the command line:
```bash
$ touch app/views/quotes/index.html.erb # Notice that the file is in the ```app/views/quotes``` directory, and is called 'index' but also has '.html.erb' tacked onto it. This is important!
```
Now let's open the file we just made and put some HTML inside of it so we can see that we made it. How about '&lt;h1&gt;Quotes&lt;/h1&gt;' and refresh to see the heading (and no errors!).

#### Displaying something useful in our new view
So we've gotten past the errors, but we're not seeing much. We have to do two things in order to see anything interesting: 1. In the controller, fetch the quotes using the Quote model, and 2. In the view file, add some code to show what we have. You should by now know where these two files can be found.

In the controller, let's add some code inside our 'index' method (also sometimes called the 'index action'). When the code is done, it should look like:
```ruby
def index
  @quotes = Quote.all
end
```
This fetches all the quotes that are stored and assigns them to a variable called @quotes. Because we preceeded the variable name with an '@' sign, it will be available to refer to in the view when the view is rendered. So now let's add some code to the view...
```html
<% @quotes.each do |quote| %>
  <p>
    <blockquote>&ldquo; <%= quote.body %>&rdquo;</blockquote>
    <cite>
        &mdash;<%= quote.author %>
        <% unless quote.year.nil? %>
            in <%= quote.year %>
        <% end %>
    </cite>
    <% unless quote.verified %>
      (The origin of this quote has not been verified.)
    <% end %>
  </p>
  <hr />
<% end %>
```
Check it out. Now we're getting somewhere. If you click on the "Home" text on the screen, you may start feeling frustrated, however, that you can't get back to the quotes page. That kinda sucks, so let's go check that out. Every page of a Rails app -- by convention anyhow (i.e. if we don't tell Rails otherwise) -- will display the pages inside of a layout found in app/views/layouts/ and called application.html.erb, so let's open that file. We're looking for the links called "Home" and "Placeholder Link" so that we can add a liink to the Quotes page. Let's remove the placeholder now and replace it with:
```ruby
<li>
  <%= link_to 'Quotes', quotes_path %>
</li>
```
What is quotes_path? Why can we say that?
What happens if we replace it with, say, things_path?
Where did it come from?
Let's look at our old command line tool:
```bash
$ rake routes
```
Do you see where it came from?

#### Adding the ability to make a new quote
We need to do a couple things here. For one, we need a place to put a form. The router gave us a new_quote_path. We need an action in the controller:
```ruby
def new
  @quote = Quote.new
end
```
and some code where Rails expects to find the view for the new_quote_path, app/views/quotes/new.html.erb. We'll have to make that file:
```html
<%= form_for(@quote) do |f| %>
  <div class="field">
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </div>
  <div class="field">
    <%= f.label :author %><br>
    <%= f.text_field :author %>
  </div>
  <div class="field">
    <%= f.label :year %><br>
    <%= f.number_field :year %>
  </div>
  <div class="field">
    <%= f.label :verified %><br>
    <%= f.check_box :verified %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```
If we visit 'http://localhost:3000/quotes/new' we see a form, but when we submit it, nothing happens. That's because we haven't made a "create" action (method) in the controller, so here we go:
```ruby
def create
  @quote = Quote.new(quote_params)

  if @quote.save
    redirect_to quotes_path
  else
    render :new
  end
end
```
and at the bottom of the file as a private method:
```ruby
private

def quote_params
  params.require(:quote).permit(:body, :author, :year, :verified)
end
```

Lastly we need a way to get to the new quote form other than typing in the URL manually, cuz like who's gonna do that?! We'll put it in the index view we made earlier just beneath the h1 Quotes heading:
```html
<%= link_to "Add a quote", new_quote_path %>
```

#### Doing a bunch of this yourself!
Repeat the whole process above, this time making a Post instead of a Quote. Add a way to list them and add them. Go back through the directions we just used and notice where small changes need to be made. The post should have similar fields but slightly different (body, author, number of likes, and whether or not it has been published yet). When making your seeds.rb file, be sure to make at least one post that has been published and one that has NOT. The absolute biggest deviation will be in your index view, in which you should display a Post only if it has been published. See if you can see the patterns for conditionally showing things. In some ways the Quote display is more complex. Mentors will be standing by to assist!

#### Extra exploration
With the help of your mentor, see if you can figure out how to EDIT a Post. You'll have to change the view to show all posts and state whether published or not (more like the Quote example). You'll also have to add an edit link. Remember how Rails made us routes with names like quotes_path. Is there an edit path made for us? Hint: YES! See if you can find it. See if you can use http://guides.rubyonrails.org/routing.html section 2.3 to figure out what additional information you need to supply to use it.
If you get to this, you'll notice that the forms for editing and creating a new Post look remarkably similar. Your mentors can teach you how to observe the DRY principle here.

