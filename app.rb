require 'sinatra'
require_relative 'database_setup'

# Helper method to validate input 
def validate_item(name, email, price)
    errors = [] 

    # check for empty name 
    if name.nil? || name.strip.empty?
        errors << "Name cannot be blank."
    end

    # check for valid price
    if price.nil? || price.strip.empty?
        errors << "price cannot be blank."
    elsif price.to_s !~ /\A\d+(\.\d{1,2})?\z/
        errors << "Price must be a valid number."
    end

    # validate email
    email_errors = validate_email(email)
    errors.concat(email_errors)

    errors
end

# validate email using the method above
def validate_email(email)

    errors = []

    # Regular expression for email validation
    email_regex = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/

    # check if email is blank
    if email.nil? || email.strip.empty?
        errors << "Email cannot be blank."
    elsif email !~ email_regex
        # check if email matches the regular expression
        errors << "Email format is invalid"        
    end

    errors
end


# Read all items
get '/' do
    @items = DB.execute("SELECT * FROM items")
    erb :index
end

# Form to create a new item
get '/items/new' do
    @errors = []
    erb :new
end

# Create a new item
post '/items' do
    @errors = validate_item(params[:name], params[:email], params[:price])

    if @errors.empty?
        DB.execute("INSERT INTO items (name, email, price) VALUES (?, ?, ?)", [params[:name], params[:email], params[:price]])
        redirect '/'
    else 
        erb :new
    end
end

# Form to edit a item
get '/items/:id/edit' do
    @item = DB.execute("SELECT * FROM items WHERE id = ?", [params[:id]]).first
    @errors = []
    erb :edit
end

# Update a item
post '/items/:id' do
    @errors = validate_item(params[:name], params[:email], params[:price])

    if @errors.empty? 
        DB.execute("UPDATE items SET name = ?, email = ?, price = ? WHERE id =?", [params[:name], params[:email], params[:price], params[:id]])
        redirect '/'
    else 
        @item = { 'id' => params[:id], 'name' => params[:name], 'email' => params[:email], 'price' => params[:price]}
        erb :edit
    end
end

# DELETE a item
post '/items/:id/delete' do
    DB.execute("DELETE FROM items WHERE id = ?", [params[:id]])
    redirect '/'
end