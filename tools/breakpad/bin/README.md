
# Runtime errors

If these don't work for you (gcc lib less than 4.8), just build them and grab them from our breakpad repo

# Usage

The build should output a symbols file in plex/build, grab that file (or the one from the associated release), and put it in a directory structure as detailed by the [google breakpad docs(http://code.google.com/p/google-breakpad/wiki/LinuxStarterGuide#Producing_symbols_for_your_application)

Take the dump file from the server, and run it like this:


```
  ./minidump_stackwalk ./crash_X.dump ./symbols
```
