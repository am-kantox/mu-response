# μResponse

To start your `μResponse` app:

  1. Install dependencies with `mix deps.get`
  2. Download [`inotify`](file watcher) and install it:
    1. `git clone git@github.com:am-kantox/inotify.git`
    2. `cd inotify && aclocal && autoconf && automake --add-missing && ./configure && make && make install`
  3. ~~Create and migrate your database with `mix ecto.create && mix ecto.migrate`~~ this step is not needed yet
  4. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
