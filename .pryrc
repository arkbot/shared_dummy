if defined?(Rails::Console)
  if defined?(BetterErrors)
    require 'awesome_print'

    begin
      require 'pry-byebug'
      require 'pry-stack_explorer'
    rescue LoadError
      nil
    end

    Pry.config.pager = :less

    AwesomePrint.pry!
  end
else
  Pry.config.pager = false
end
