# Rails api with Swagger and json-api spec

Example rails 5 api application which attempts to use the Document-Driven development approach with OpenAPI to drive development of an api which
conforms to the json-api spec

# About OpenAPI, Swagger

OpenAPI  is a API description format for RESTFul web services.

[Swagger]{:target="_blank"} provides the tooling around OpenAPI specification that allows you to build, develop, test and document your apis.

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

* Add authentication and integration specs

* Refactor the error responses to be json-api compliant
