# FootbalInterface

## What is it

Interface for the Football application. This project is the shell around the
FootbalEngine project and it exposes the Engine's functionality to the world via
a simple REST API.

## API

The public API has 2 endpoints:

- `/ping`
- `/search`

### ping

Dummy endpoint that always returns `"ok"`. Used mainly to check if
the server is up and running.

### search

The search endpoint allows the users to query the data in the CSV by means of a
simple indexed table in memory.

Each column in the CSV can be queried. Following is an example of a query for
all games with `Div=SP1` and `Season=201617`.

`/search?Div=SP1&Season=201617`

That's it!

If you want you can also search for teams with games in different seasons, by
performing an OR request:

`/search?Season=201617,201819`

This query will search for teams with both games in season 201617 or 201819.
You can also mix AND with OR clauses:

`/search?Div=SP1,SP2&Season=201617`

This query would return teams in Div SP1 or SP2 AND with games in Season 201617.

By default, answers to your queries will be in JSON. However you can pass a
special parameter called `format` and specify the format in which you want your
response:

`/search?Div=SP1,SP2&Season=201617&format=protobuff`

Note: if you want to search for games in a specific date, you can also do it but
the format is `YYYY-MM-DD`. For example, to get all games that happened the 1st
of April in 2017:

`search?Date=2017-04-01`

You can also search for all games by passing an empty Header:

`search?Div`

Will search for all games.

## How to use it

You can launch this app by running `iex -S mix`. That's it !
If you want to learn more you can check the [official documentation](https://fl4m3ph03n1x.github.io/footbal_interface/api-reference.html).

## Docker

This projects offers a convenient `Dockerfile` that will clone the latest
version of the project for you to run on you local machine. To make use of it
download the image:

`docker pull fl4m3ph03n1x/footbal_app`

And then execute:

`docker run -p 8080:8080 IMAGE`

Then connect to `localhost:8080` to start testing the API!

## Docker Swarm

You can also create a swarm of little footbal apps, balanced by an HAProxy
balancer.

To do it you need to run the following commands:

1. `docker swarm init`
2. `docker stack deploy --compose-file=docker-compose.yml prod`
3. Enjoy!

After running these commands you can go to `localhost/ENDPOINT_NAME` and start
using the swarm! Your requests will be redirected to the machine with least
connections (preferred that over roundrobin) and you won't even know it.

To confirm everything is running as expected, you can check the stack with the
`docker service ls` command.

Hope you enjoy!
