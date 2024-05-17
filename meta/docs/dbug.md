# `%fund` Debugging

Enabling debug mode in `%fund` is simple; just run these commands to enable it:

```
|cp /=fund=/cfg/xtra/verb/hoon /=fund=/cfg/verb/hoon
-fund!web-reload-
```

and these commands to disable it:

```
|rm /=fund=/cfg/verb/hoon
-fund!web-reload-
```

For more information on different configuration options, see the contents of
the `/desk/bare/cfg/xtra` directory.
