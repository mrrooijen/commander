## v0.3.5

* Tweaked help screen display format.
* Optionally allow for descriptive arguments for short- and long flags.
  * Enable them by adding, for example, `DIR` in `-d DIR` and/or `--directory DIR`.
* Optionally treat unmapped flags as arguments.
  * Enable this feature at the command level by setting `ignore_unmapped_flags = true`.
* Support for receiving anything after `--` in the command-line as arguments.
  * For example `my_program -v -d /var/log -- --this-is-an-argument`.

## v0.3.4

* Added support for persistent flags.
