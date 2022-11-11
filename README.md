# Template for apt source list

> **Warning**
> Intended for debian-based ditributions only with use of [Apt](https://en.wikipedia.org/wiki/APT_(software)).

## Source list

You have to rename the `sources-<branch>.list` to `sources.list` and put it in the `/etc/apt/` folder.

For each kind of repository:

- I use the official [closest mirror server](https://www.debian.org/mirror/list) to download faster.
- I use all the sections available to have the richest package library ([main contrib non-free](https://wiki.debian.org/SourcesList#Component)).

### Stable branch or Testing branch

For the stable branch, there is a `source-stable.list` with several repositories.
For the testing branch, there is also a `source-testing.list` with the same repositories:

- `Stable` for standard update source
- `Stable-security` for standard security update source
- `Stable-backports` for more recent versions of some packages
- `Stable-proposed-updates` for upcoming point releases packages
- `Stable-updates` for package changes that cannot wait for the next point release

> **Warning**
> There is some tiny problem with the stable repositories, the codenames doesn't match with the `stable` tag but with the current **debian codename distribution**.

```bash
$ curl -fsSL 'http://ftp.fr.debian.org/debian/dists/stable-backports/Release' | grep -E '^Suite|^Codename'
Suite: bullseye-backports
Codename: bullseye-backports
$ curl -fsSL 'http://ftp.fr.debian.org/debian/dists/stable-proposed-updates/Release' | grep -E '^Suite|^Codename'
Suite: proposed-updates
Codename: bullseye-proposed-updates
```

So when you will do `apt update`, you will get some warnings like this:

```bash
W: Conflicting distribution: http://ftp.fr.debian.org/debian stable-backports InRelease (expected stable-backports but got bullseye-backports)
W: Conflicting distribution: http://ftp.fr.debian.org/debian stable-proposed-updates InRelease (expected stable-proposed-updates but got 
bullseye-proposed-updates)
```

These warnings are harmless but quite annoying, to get rid of them juste replace the `stable` tag in `stable-backports` and `stable-proposed-updates` with your current codename distribution.

You can get it with `lsb_release -sc` or `cat /etc/os-release | grep -P "(?<=VERSION_CODENAME=).*"`

```bash
echo $(lsb_release -sc)-proposed-updates
echo $(lsb_release -sc)-backports
```

### Custom source lists

There is also some custom source files in `sources.list.d` to have for example the  spotify, vscode or kali-branch packages.
They aren't default packages and relies on external repositories, so you have to add  for each repository you want it's [own gpg key](https://wiki.debian.org/SecureApt#How_to_find_and_add_a_key).

The `debian-archive-keyring` package is used to distribute keys to apt. Upgrades to this package can add (or remove) gpg keys for the main Debian archive.

For **other archives**, there is not yet a standard location where you can find the key for a given apt repository.

There's a rough standard of putting the key up on the web page for the repository or as a file in the repository itself, but no real standard, so you might have to hunt for it.

You can also check on a public key server provider and try to found the desired key by repository name or key ID:

- <https://keys.openpgp.org/>
- <https://keyserver.ubuntu.com/>
- <https://keyring.debian.org/>

Be sure to verify the source and the [veracity](https://wiki.debian.org/SecureApt#How_to_tell_if_the_key_is_safe) of the gpg key you want to add.

After finding this key you must know the kind of gpg key you are [dealing with](https://www.linuxuprising.com/2021/01/apt-key-is-deprecated-how-to-add.html).
Run `file <repo-key>.gpg`, if you get a similar to the following then the key is **ascii-armored**:

```bash
$ file <repo-key>.gpg
repo-key.gpg: PGP public key block Public-Key (old)
```

For [armored key](https://manpages.debian.org/stable/gpg/gpg.1.en.html#dearmor):

```bash
gpg --dearmor --export <repo-key>.gpg
```

For non armored key:

```bash
gpg --export <repo-key>.gpg
```

And finaly you have to put it in the `/etc/apt/trusted.gpg.d` [folder](https://wiki.debian.org/SecureApt#Basic_concepts) in a file ending with `.gpg`.

Final command to download the gpg key and put it directly into a custom file (if gpg armored file):

```bash
curl <https://example.com/key/repo-key.gpg> | gpg --dearmor > /etc/apt/trusted.gpg.d/<desired_repository_name>.gpg
```

or

```bash
wget -O- <https://example.com/key/repo-key.gpg> | gpg --dearmor > /etc/apt/trusted.gpg.d/<desired_repository_name>.gpg
```

To list all gpg keys, type `apt-key list`

## Preferences

The `preferences.d` folder contain preference files for several branch repositories.

In these files, there is priority assigned to each branch repository regarding to it's optionality or it's bleeding edge versioning,more a priority is high, more it will be used for dowloading and upgrading packages because apt always install the highest priority version.

If two or more versions have the same priority, apt will install the most recent one (that is, the one with the higher version number).

**stable but not newest** packages repositories have always the **highest priority** in my configuration.

So for the [moment](https://manpages.debian.org/bullseye/apt/apt_preferences.5.en.html#How_APT_Interprets_Priorities):

- `kali` have a **very low priority** because it is fully optionnal and stand for the kali linux repositories, causes a version to be installed only if there is no installed version of the package,for forcing installation by this repository use the `-t` flag with apt.  
<https://wiki.debian.org/AptConfiguration#Force_installation_of_a_package_from_a_repository>
<https://manpages.debian.org/bullseye/apt/apt_preferences.5.en.html#APT's_Default_Priority_Assignments>

- `unstable` have a **low priority**, causes a version to be installed unless there is a version available belonging to some other distribution or the installed version is more recent.

- `testing` have a **medium priority**, it behave like `unstable`, it will never outrun `stable` unless there is no **stable** branch in the `sources.list` or `source.list.d`.

- `stable` have a **high priority**, causes a version to be installed even if it does not come from the target release, unless the installed version is more recent.
  
## Installation of softwares

In `installation-softwares.sh`, there is a bunch of usefull software to install if for exmpale you have a nvidia card and want the latest drivers according to a newer debian branch [stable-backports](https://wiki.debian.org/Backports).
