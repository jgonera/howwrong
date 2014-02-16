# How Wrong You Are

## Development setup

* Install PostgreSQL.
* Create database user, development database and test database using `psql`
  (`sudo -u postgres psql`):

```sql
create user howwrong with password 'q';
create database howwrong_development;
grant all privileges on database howwrong_development to howwrong;
create database howwrong_test;
grant all privileges on database howwrong_test to howwrong;
```

## Running tests

```bash
$ bin/rspec
```
