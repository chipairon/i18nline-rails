class HelloController < ApplicationController
  def hello

  end

  def login
    #this sets the current user to a dummy user, to simulate a login.
    current_user
    render "hello", notice: "Thanks for login in"
  end
end
