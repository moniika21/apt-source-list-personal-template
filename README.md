# Template for apt source list

> **Warning**
> Intended for debian-based ditributions only with use of [Apt](https://en.wikipedia.org/wiki/APT_(software)).

## Source list

You have to rename the `sources-<branch>.list` to `sources.list` and putting it in the `/etc/apt/` folder
 main contrib non-free
 Official french repository

### Stable branch or Testing branch

For the stable branch, there is a `source-stable.list` with several repositories.
For the testing branch, there is also a `source-testing.list` with the same repositories:

- `Stable` for standard update source
- `Stable-security` for standard security update source
- `Stable-backports` for more recent versions of some packages
- `Stable-proposed-updates` for upcoming point releases packages
- `Stable-updates` for package changes that cannot wait for the next point release

> **Warning**
> There is some tiny problem with the stable repositories, the codenames doesn't match with the `stable` tag but with the current `debian codename distribution`.

```bash
moniika@raspberry:~$ curl -fsSL 'http://ftp.fr.debian.org/debian/dists/stable-backports/Release' | grep -E '^Suite|^Codename'
Suite: bullseye-backports
Codename: bullseye-backports
moniika@raspberry:~$ curl -fsSL 'http://ftp.fr.debian.org/debian/dists/stable-proposed-updates/Release' | grep -E '^Suite|^Codename'
Suite: proposed-updates
Codename: bullseye-proposed-updates
moniika@raspberry:~$ curl -fsSL 'http://ftp.fr.debian.org/debian/dists/stable-updates/Release' | grep -E '^Suite|^Codename' 
Suite: stable-updates
Codename: bullseye-updates
```

So when you will do `apt update`, you will get some warnings like this:

```bash
```

To get rid of these warnings juste replace the stable tag before -backports with your current codename distribution.

You can get it with `lsb_release -sc` or cat
cat /etc/os-release | grep "CODENAME"

### Custom

There is also some custom source files in `sources.list.d` to have for example the  spotify, vscode or kali-branch packages.
They aren't default packages and relies on external repositories, so you have to add  for each repository you want to add it's [own gpg key](https://wiki.debian.org/SecureApt#How_to_find_and_add_a_key).

The `debian-archive-keyring` package is used to distribute keys to apt. Upgrades to this package can add (or remove) gpg keys for the main Debian archive.

For `other archives`, there is not yet a standard location where you can find the key for a given apt repository.

There's a rough standard of putting the key up on the web page for the repository or as a file in the repository itself, but no real standard, so you might have to hunt for it.

Be sure to verify the source and the [veracity](https://wiki.debian.org/SecureApt#How_to_tell_if_the_key_is_safe) of the gpg key you want to add.

And after finding this key you must know the kind of gpg key you are dealing with:

- Armored key

- Non armored key

And finaly you have to put it in the `/etc/apt/trusted.gpg` [folder](https://wiki.debian.org/SecureApt#Basic_concepts).

To list all gpg keys, type `apt-key list`

## Preferences

## Installation of softwares

In `installation-softwares.sh`, there is a bunch of usefull softawre to install if for exmpale you have a nvidia card and want the latest drivers according to a newer debian branch [stable-backports](https://wiki.debian.org/Backports).
