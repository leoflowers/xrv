# xrv

A tool for automatically saving Git repos.

## Usage

After you build your binary, stick it in `${PROJECT}/.bin` and add the following to your crontab: `*/5 * * * ${PROJECT}/.bin/xrv` (change the duration to any desired frequency).

## Building

Run `make xrv` to build.
