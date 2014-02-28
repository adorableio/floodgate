namespace :floodgate do
  desc 'Display the floodgate status'
  task :status => :environment do
    status = Floodgate::Client.status

    status.each_pair do |key, value|
      puts "#{key}: #{value}"
    end
  end

  desc 'Close the floodgate'
  task :close => :environment do
    Floodgate::Client.close
  end

  desc 'Open the floodgate'
  task :open => :environment do
    Floodgate::Client.open
  end

  desc 'Set the URL floodgate redirects to when filtering traffic'
  task :set_redirect_url => :environment do
    redirect_url = ENV['redirect_url']

    Floodgate::Client.set_redirect_url(redirect_url)
  end

  namespace :ip_address do
    desc 'Display a list of allowed IP Addresses'
    task :all => :environment do
      puts Floodgate::Client.allowed_ip_addresses
    end

    desc 'Show my IP Address'
    task :mine do
      puts Floodgate::Client.my_ip_address
    end

    desc 'Add an IP Address to allow through the floodgate'
    task :add => :environment do
      ip_address = ENV['ip_address']

      Floodgate::Client.add_ip_address(ip_address)
    end

    desc 'Add my IP Address to the list allowed through the floodgate'
    task :add_mine => :environment do
      Floodgate::Client.add_my_ip_address
    end

    desc 'Remove an IP Address from the list allowed through the floodgate'
    task :remove => :environment do
      ip_address = ENV['ip_address']

      Floodgate::Client.remove_ip_address(ip_address)
    end

    desc 'Remove my IP Address from the list allowed through the floodgate'
    task :remove_mine => :environment do
      Floodgate::Client.remove_my_ip_address
    end

  end
end

