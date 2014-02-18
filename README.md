# How Wrong You Are

## Development setup

Install PostgreSQL and create a database user using `sudo -u postgres psql`:

```sql
create user howwrong with password 'q';
alter user howwrong createdb;
```

Then run `bin/rake db:setup`

## Running tests

```bash
$ bin/rake
```
