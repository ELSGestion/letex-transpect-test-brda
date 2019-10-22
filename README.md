# letex-transpect-tests
Test repo to use letex transpect tool to automate inDesign generation

## Test-1 : EFL Revue BRDA


## git

### Submodules

In order to keep submodules up to date, you need to specify `--recurse-submodules` for `git clone` and `git pull` Alternatively, you can set it globally:

```bash
git config --global fetch.recurseSubmodules true
```
Unfortunately, this doesn’t work so well with recursively nested submodules, and also if some of them don’t track the master branch, as does the calabash submodule.

```bash
$ git clone [this repo’s URL]
$ cd [the local directory]
[the local directory]$ git submodule update --init
[the local directory]$ cd calabash
[the local directory]/calabash$ git checkout saxon98
[the local directory]/calabash$ git submodule update --recursive --rebase --init
```

Check that
```bash
[the local directory]/calabash/distro/xmlcalabash-1.1.22-98.jar
```
exists and the subfolders of
```bash
[the local directory]/calabash/extensions/transpect
```
aren’t empty.
