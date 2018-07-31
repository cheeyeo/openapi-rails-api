# Rails 5.2 Api with Swagger and json-api spec

Example Rails 5.2 Api application which attempts to use the `Document-Driven` development approach with `OpenAPI` to drive development of an api which
conforms to the json-api spec

This example application also uses `oauth2` with `doorkeeper` and integrating the oauth flow into the swagger UI

# Running the example:

Run `bin/setup` which will also run the `db:seed` task to create the Swagger user and application models needed for oauth.

Ensure that the details matches that of `config/initializers/rswag-ui.rb`, especially for the redirect uris and the client id and secret.


To generate the swagger json file after editing:
```
bundle exec rake rswag:specs:swaggerize # => generates the swagger json spec
```

You can access the Swagger UI at `http://localhost:3000/api-docs/index.html`

To create an authenticated connection, you need to click on 'Authorize'


# About Swagger UI

By defining the `security` definitions for oauth2 within the json spec, the UI
generates an `Authorize` link on the page which allows you to integrate the UI
with your oauth flow.

This allows you to test the authenticated endpoints within the same UI.

I found some issues while setting it up:

* The UI passes the `code` params intermingled with its own `state` params as one, which throws a `401` error as it cannot find the `AccessGrant` with an invalid code. I had to create custom `Doorkeeper` tokens controller to handle this.

* The UI does not maintain state on the token obtained. If you refresh the page, the Bearer token is gone. If you make a subsequent call, you will get a `Token already exists` error. The solution I came up with was to find the token and
delete it if it exists for each call to `/api-docs` within `Doorkeeper Tokens controller`

* The UI opens a new window after clicking `Authorize` which redirects to the uri
specified in `config/initializers/rswag-ui.rb` which is `http://localhost:3000/oauth-redirect.html`. Since `Doorkeeper` is setup in `api_mode` it only returns
a json response. This is fixed using a custom `Doorkeeper authorizations` controller which redirects back to the window if the path matches `api-docs` even in `api_mode`


# About OpenAPI, Swagger

OpenAPI  is a API description format for RESTFul web services.

[Swagger] provides the tooling around OpenAPI specification that allows you to build, develop, test and document your apis.

One of the swagger tooling, ```swagger-ui``` presents a complete UI to test and validate your api in the browser.

The api specs are powered by ```rswag``` which allows you to describe the integration specs in swagger format. It also includes a rake task to build
the swagger definition:

```
bundle exec rake rswag:specs:swaggerize
```

The swagger definition are stored in ```swagger/<filename>``` but can be changed
in ```config/initializers/rswag-api.rb```


[Swagger]: https://swagger.io/docs/specification/about/


# TODO

* Add api endpoint and specs for User model

* Create / learn more about OAUTH scopes and update the openapi specs

* Add TodoListItem and update api specifications

* Change to another database i.e. postgresql etc
