# hedwig_trivia

A [Hedwig](https://github.com/hedwig-im/hedwig) plugin to play trivia via the
[jservice](http://jservice.io/) API.

## Installation

The package can be installed by adding `hedwig_trivia` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hedwig_trivia, "~> 0.1.0"}
  ]
end
```

Docs can be found at
[https://hexdocs.pm/hedwig_trivia](https://hexdocs.pm/hedwig_trivia).

## Usage

```
hedwig trivia
# fetches a new trivia question from the API, unless you already have an
# unanswered question

hedwig trivia!
# fetches a new trivia question from the API, regardless of whether you already
# have an unanswered question

hedwig guess <guess>
# submit a guess for the current question

hedwig solution
# get the answer to the current question
```

## Development

`mix deps.get`
`mix test`
`bin/lint`

## License

MIT

## Acknowledgements

[@sottenad](https://github.com/sottenad) for the API
[@scrogson](https://github.com/scrogson) for Hedwig
