# [Floodgate]()

## What is it?

You've spent the last few weeks improving significant portions of your application and you're ready to deploy. The maintenance page goes up, the code is pushed, and doubt creeps in as to whether things are actually working. Did you remember to update those third party keys? Is that very clever code your co-worker wrote working as expected? Is there anything different about your production environment that's going to cause things to fail?

As developers we'd all prefer to live in a world where we're continuously deploying all of our test-driven code all the time. In reality, the process typically looks a little broken. Imagine being able to spend a few minutes with your app smoke testing to make sure everything works. With Floodgate in place you are able to provide access to developers, testers, and the product owner to click through and see things work the way they are supposed to <strong>in production</strong> before releasing your product to all of your customers.

## Getting Started

Install Floodgate as a gem.

    gem install floodgate

or by adding it to your Gemfile.

    gem 'floodgate'

Then create an account at [Floodgate.io](http://floodgate.io). Once you receive your welcome email you can configure the middleware with one-line.

    config.middleware.use Floodgate::Control, [YOUR_APP_ID], [YOUR_API_TOKEN]

Now that you've configured the floodgate you can check its status.

    $ rake floodgate:status
    allowed_ip_addresses: []
    filter_traffic: false
    name: your-app-name
    redirect_url:

The floodgate is open by default and no traffic is filtered. You can close the floodgate with the following rake task.

    $ rake floodgate:close

When using Heroku you will also need to restart your dyno for changes to take effect.

    $ heroku restart

Checking its status we can see that we are now filtering traffic.

    $ rake floodgate:status
    allowed_ip_addresses: []
    filter_traffic: true
    name: your-app-name
    redirect_url:

Visitors to the configured site will now receive a status 503 Service Unavailable. That seems less than ideal. Let's redirect them to a status page to let them know to try back in a few minutes.

    $ rake floodgate:set_redirect_url redirect_url=http://bit.ly/1kw8F6q

Now its status includes the redirect URL

    $ rake floodgate:status
    allowed_ip_addresses: []
    filter_traffic: true
    name: your-app-name
    redirect_url: http://bit.ly/1kw8F6q

When we visit the site (remember to restart Heroku if needed) we are now whisked away to the redirect URl. This is configured as a temporary redirect to minimize the impact from search engine spiders and other crawlers.

But, wait! How do we get in to smoke test? You'll need to determine what your IP address is as interpreted by the outside world.

    $ rake floodgate:ip_address:add_me

Checking its status we see now have an allowed IP address.

    $ rake floodgate:status
    allowed_ip_addresses: ["24.240.74.8"]
    filter_traffic: true
    name: your-app-name
    redirect_url: http://bit.ly/1kw8F6q

If we go back to the configured site (restart heroku if needed) and reload … We're in! We can smoke test and make sure things work as expected and when we're done let the rest of the internet in with the following command.

    $ rake floodgate:open
    $ rake floodgate:status
    allowed_ip_addresses: ["24.240.74.8"]
    filter_traffic: false
    name: your-app-name
    redirect_url: http://bit.ly/1kw8F6q

Restart Heroku and everyone can now access the application again, hooray!

### Support

* [Github Wiki](https://github.com/adorableio/floodgate/wiki)
* [Github Issues](https://github.com/adorableio/floodgate/wiki)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
