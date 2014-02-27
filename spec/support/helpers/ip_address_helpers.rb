require 'ipaddr'

def random_ip_address
  IPAddr.new(rand(2**32), Socket::AF_INET).to_s
end

