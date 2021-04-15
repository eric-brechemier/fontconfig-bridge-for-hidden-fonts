# fontconfig-bridge-for-hidden-fonts
Help Fontconfig to discover hidden fonts.

## Usage

Run the script `help-fontconfig-discover-hidden-fonts-for.sh`
to refresh the list of fonts available in Fontconfig:

```
$ ./help-fontconfig-discover-hidden-fonts-for.sh [name] [cache]
```

The script takes two parameters:

* ***name***: used to create a distinct folder for each font service
* ***cache***: location of the parent folder of hidden fonts

For each hidden font in the hidden cache folder of the subscription service,
the script creates a symbolic links in a location known to Fontconfig,
in a subfolder with the given service name.

For example, if you are subscribed to a fictitious font subscription service
called fontitious which stores its fonts locally as hidden font files in the
folder `~/Library/Application Support/Fontitious/.fonts/`, you would need to
call the script after each change in your font subscriptions as:

```
$ ./help-fontconfig-discover-hidden-fonts-for.sh fontitious \
              ~/Library/Application Support/Fontitious/.fonts
```

I am using this script on macOS Catalina the hidden fonts
get listed successfully in Gimp, Krita, Inkscape and Scribus
after running the script and restarting each app.

## Rationale

Font subscription services tend to store their fonts on the local drive
of the subscribers as hidden files in a hidden cache folder.

While scanning font folders recursively, [Fontconfig][] silently ignores
any hidden file or folder. It is still possible to get Fontconfig to consider
a hidden font folder, such as `~/.fonts`, when it is included explicitly
in Fontconfig configuration. But there is currently no way to make Fontconfig
consider hidden font files.

The source code explicitly filters out any file name starting with a `.`:

```
    while ((e = readdir (d)))
    {
	if (e->d_name[0] != '.' && strlen (e->d_name) < FC_MAX_FILE_LEN)
	{
	    strcpy ((char *) base, (char *) e->d_name);
	    if (!FcStrSetAdd (files, file_prefix)) {
		ret = FcFalse;
		goto bail2;
	    }
	}
    }
```
— [fontconfig/src/fcdir.c, 256–266](https://gitlab.freedesktop.org/fontconfig/fontconfig/-/blob/fd3eebad741c0fdfce2a7e44f9b3ac8895b70a58/src/fcdir.c#L258)

This project offers a simple workaround by creating symbolic links for hidden
font files in a subfolder of one of the local folders configured in Fontconfig.

## References

* [1] [Fontconfig][]
* [2] [man fonts-conf](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html)
* [3] [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
* [4] [Fontconfig source repository](https://gitlab.freedesktop.org/fontconfig/fontconfig)

[Fontconfig]: https://www.freedesktop.org/wiki/Software/fontconfig/

## Author

Eric Bréchemier

## License

[CC0](https://creativecommons.org/share-your-work/public-domain/cc0/)
