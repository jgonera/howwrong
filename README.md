[![Build Status](https://travis-ci.org/jgonera/howwrong.svg?branch=master)](https://travis-ci.org/jgonera/howwrong)
[![Ready stories](https://badge.waffle.io/jgonera/howwrong.png?label=ready&title=Ready)](https://waffle.io/jgonera/howwrong)
[![Stories in progress](https://badge.waffle.io/jgonera/howwrong.png?label=in%20progress&title=In%20Progress)](https://waffle.io/jgonera/howwrong)

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

Or faster (but doesn't migrate DB):

```bash
$ bin/rspec
```
