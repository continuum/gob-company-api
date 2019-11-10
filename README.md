# GoB Company API

A (so far) quick and dirty API server for accesing Get on Board from a company
perspective.

See it live:

[![asciicast](https://asciinema.org/a/hAC5d7VefBt3yEQ2FX5cJKQOP.svg)](https://asciinema.org/a/hAC5d7VefBt3yEQ2FX5cJKQOP)

## Development

It's a simple Rails 6 API codebase. Contributions are very welcomed :)

### Tests

For integration tests you need a valid Get on Board username and password. Set
them as environment variables `GOB_USERNAME` and `GOB_PASSWORD`, for example 
via:

```bash
$ export GOB_USERNAME='your-account@example.org'
$ export GOB_PASSWORD='yoursupersecretpassword'
```

Then you can run:

```bash
$ rake spec
```

And tests should pass