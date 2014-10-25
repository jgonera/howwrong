# How Wrong You Are

## Development setup

Install PostgreSQL and create a database user using:

```bash
$ createuser -d -W howwrong
```

Then run:

```bash
$ bin/rake db:setup
```

## Running tests

```bash
$ bin/rake
```
