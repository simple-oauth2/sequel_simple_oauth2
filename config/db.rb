DB ||= if defined?(JRUBY_VERSION)
         Sequel.connect('jdbc:sqlite::memory:')
       else
         Sequel.connect('sqlite://sequel_simple_oauth2.rb')
       end
