# Omniauth::Munic

This gem contains the MunicConnect strategy for OmniAuth.

## Installation

Add these lines to your Gemfile:

```ruby
gem 'omniauth-oauth2'
gem 'omniauth-munic'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-oauth2 omniauth-munic


## Configuration

This [git](http://gitlab.mobile-intra.com/maxime-dufay/Integrate-MunicConnect) is a sample integration of MunicConnect in an existing application. Feel free to `git log`.

### Register your application on MunicConnect

First, you need to register your application on MunicConnect. [Here](http://accounts.munic.io/oauth/applications) you can create a new application (you need to be logged in with your MunicConnect account).

* Name                : Name of your application
* Private             : If yes, MunicConnect User must be approved (by you) before be abble to sign in your application; else, any MunicConnect User can sign in.
* Authorized users    : If your application is private, this allow you to authorize users to acces your application.
* Redirect uri        : After successfull sign in on MunicConnect, customer will be redirected on your application. E.g. '[yoursite]/auth/munic/callback'. (You will re-use it [here](#Routes).)

This action can be performed with an API. For more information see [here](http://MUNICCONNECTGIT/README.md#API)

### Set Application uid and Secret
[MUNICCONNECTWEBSITE]/oauth/applications is listing all your applications. By clicking on the name of an application, you can get information about it, especially two strings of 64 hexadecimal characters long : "Application" and "Secret". _DO NOT_ share this credentials !

Put them in `config/initializers/omniauth.rb` like so :

    Rails.application.config.middleware.use OmniAuth::Builder do
        provider :munic, 'APPLICATION', 'SECRET'
    end

### Routes
In `config/routes.rb`, you must `get` the [redirect uri](#register-your-application-on-MunicConnect) and trigger an action.

Basically you will need to create a session on your site :

    get 'REDIRECT_URI', to: 'SESSION_CONTROLLER_NAME#create'

E.g.

    get '/auth/munic/callback', to: 'sessions#create_from_munic'


### Model and Controller

You have to manage your own Model User and Sessions Controller.
Above are examples.

#### Users Table
    create_table :users do |t|
        t.string :provider
        t.string :uid
        t.string :email
    end

#### User Model
    def self.create_with_omniauth(auth)
        create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.email = auth["info"].email
        end
    end

#### Session Controller
    def create_from_munic
        auth = request.env["omniauth.auth"]
        user = User.find_by_provider_and_uid(auth[:provider], auth[:uid]) || User.create_with_omniauth(auth)
        redirect_to root_url, :notice => "Signed in!"
    end

### Link to "Sign in with Munic"
    <%= link_to "Sign in with Munic", "/auth/munic" %>


### Redirect to exact same point after successfull sign in (optional)
In your Session Controller add the following line :

    redirect_to request.env["omniauth.origin"] || root_url, :notice => "Signed in!"


## Usage

### User's information
You can get user's information when [creating a session](#Session-Controller) with this line :

    auth = request.env["omniauth.auth"]
    auth["info"]

You can get :
* Email -> auth["info"].email
* Full Name -> auth["info"].full_name
* Company Name -> auth["info"].company_name
* Time Zone -> auth["info"].time_zone
* V.a.t -> auth["info"].vat
* Language -> auth["info"].language

### Update User's information
If you store information in your database, you may want to update it. This method needs the user to sign-in to update information.

#### User Model
Add this method to your user model :

    def update_info(info)
        if self.updated_at < info.updated_at
        self.update_attribute(:email, info.email)
        #update other information you have stored
        end
    end

#### Session Controller
Add this line to your session creation :

    def create_from_munic
        auth = request.env["omniauth.auth"]
        user = User.find_by_provider_and_uid(auth[:provider], auth[:uid]) || User.create_with_omniauth(auth)
        user.update_info(auth[:extra][:raw_info])       #
        redirect_to root_url, :notice => "Signed in!"
    end

