## Commander

[![Build Status](https://travis-ci.org/mrrooijen/commander.svg)](https://travis-ci.org/mrrooijen/commander)

Command-line interface builder for the [Crystal] programming language.


#### Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  commander:
    github: mrrooijen/commander
    version: ~> 0.3.5
```


#### Usage

Almost everything you need to know in one example.

Refer to the [Features](#features) section below for a list of all available features.

```crystal
require "commander"

cli = Commander::Command.new do |cmd|
  cmd.use = "my_program"
  cmd.long = "my program's (long) description."

  cmd.flags.add do |flag|
    flag.name = "env"
    flag.short = "-e"
    flag.long = "--env"
    flag.default = "development"
    flag.description = "The environment to run in."
  end

  cmd.flags.add do |flag|
    flag.name = "port"
    flag.short = "-p"
    flag.long = "--port"
    flag.default = 8080
    flag.description = "The port to bind to."
  end

  cmd.flags.add do |flag|
    flag.name = "timeout"
    flag.short = "-t"
    flag.long = "--timeout"
    flag.default = 29.5
    flag.description = "The wait time before dropping the connection."
  end

  cmd.flags.add do |flag|
    flag.name = "verbose"
    flag.short = "-v"
    flag.long = "--verbose"
    flag.default = false
    flag.description = "Enable more verbose logging."
    flag.persistent = true
  end

  cmd.run do |options, arguments|
    options.string["env"]    # => "development"
    options.int["port"]      # => 8080
    options.float["timeout"] # => 29.5
    options.bool["verbose"]  # => false
    arguments                # => Array(String)
    puts cmd.help            # => Render help screen
  end

  cmd.commands.add do |cmd|
    cmd.use = "kill <pid>"
    cmd.short = "Kills server by pid."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
      arguments # => ["62719"]
    end
  end
end

Commander.run(cli, ARGV)
```

Here's what the help page looks like for this configuration:

```
$ my_program help

my_program - my program's (long) description.

Usage:
  my_program [command] [flags] [arguments]

Commands:
  help [command]  Help about any command.
  kill <pid>      Kills server by pid.

Flags:
  -e, --env      The environment to run in. default: 'development'
  -h, --help     Help for this command.
  -p, --port     The port to bind to. default: 8080
  -t, --timeout  The wait time before dropping the connection. default: 29.5
  -v, --verbose  Enable more verbose logging.
```

This is how you override the default options and pass in additional arguments:

```
$ my_program -ve production --port 8443 --timeout=25 arg1 arg2 arg3 -- arg4 --arg5
```

```crystal
cmd.run do |options, arguments|
  options.string["env"]    # => "production"
  options.int["port"]      # => 8443
  options.float["timeout"] # => 25.0
  options.bool["verbose"]  # => true
  arguments                # => ["arg1", "arg2", "arg3"]
end
```


#### Features

- Define commands recursively
- Define flags on a per-command basis
  - Short argument flags (`-p 8080`)
  - Short boolean flags (`-f`)
  - Multi-short flags (`-fp 8080`, equivalent to `-f -p 8080`)
  - Long argument flags (`--port 8080`, `--port=8080`)
  - Long boolean flags (`--force`)
  - Share flags with multiple commands (`verbose = Commander::Flag.new`)
  - Persistent flags for recursively inheriting flags from a parent command (`flag.persistent = true`)
  - Global flags by defining persistent flags on the root command (`flag.persistent = true`)
  - Default values for each flag
  - Automatically validates, parses and casts to the correct type
    - Automatically passes all parsed `options` to `cmd.run`
- Receive additional cli arguments per command (`arguments` in `cmd.run`)
- Receive unmapped flags as arguments (`cmd.ignore_unmapped_flags = true`)
- Receive all input after `--` as arguments
- Automatically generates a help page for each command
  - Generates a `help` command for each command to access the help page
  - Generates `-h, --help` flags for each command to access to help page
- Provide `Commander.run(cli, ARGV)` to handle end-user input exceptions.


#### File Structure and Testing

Refer to [this answer](https://github.com/mrrooijen/commander/issues/13#issuecomment-320645899).


#### Contributing

1. Fork it ( https://github.com/mrrooijen/commander/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

[Crystal]: http://crystal-lang.org
