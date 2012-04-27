module Sorcery
  module TestHelpers
    module Rails
      def login_user_post(user, password)
        if page.driver.is_a?(Capybara::Selenium::Driver) # selenium test
          visit login_path
          fill_in "username", with: @user.username
          fill_in "password", with: 'secret'
          click_button "Log in"          
        else
          page.driver.post(sessions_url, { username: user, password: password}) 
        end
      end
    end
  end
end