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
$ git clone [this repo’s URL] [localdir]
$ cd [localdir]
[localdir]$ git submodule update --init
[localdir]$ cd calabash
[localdir]/calabash$ git checkout saxon98
[localdir]/calabash$ git submodule update --recursive --rebase --init
```

Check that
```bash
[localdir]/calabash/distro/xmlcalabash-1.1.22-98.jar
```
exists and the subfolders of
```bash
[localdir]/calabash/extensions/transpect
```
aren’t empty.

## Invocation

First make sure that there is a content directory. The location has the _canonical URI_ `http://lefebvre-sarrut.eu/content-repo/` that will be resolved by an XML catalog to a local directory.

If there is no override in xmlcatalog/content-repo.catalog.xml, the location will be resolved using [xmlcatalog/content-repo.default.catalog.xml](https://github.com/ELSGestion/letex-transpect-tests/blob/master/xmlcatalog/content-repo.default.catalog.xml), which points to the directory next to `[localdir]` (the project directory).

The canonical content repo URI will also be used in the [configuration file](https://github.com/ELSGestion/letex-transpect-tests/blob/master/conf/transpect-conf.xml) (in the attribute `/*/@content-base-uri`), and together with the paths calculation XSLT whose location is given in `/*/@paths-xsl-uri` it will be used to calculate  the directory where the generated IDML files will be stored. This paths calculation XSLT parses file names and returns an XProc `/c:param-set` document with, among other things, the _configuration cascade_ paths (where the converter will look for configurations). The mapping rules from file names to paths are preliminary.

Suppose the input file resides in `../content/ELS/BRDA/172019/xml/BRDA172019_print.xml`. Then an invocation via `calabash.sh` from `[localdir]` looks like:

```bash
calabash/calabash.sh -o html=out.html -i conf=conf/transpect-conf.xml -i source=../content/ELS/BRDA/172019/xml/BRDA172019_print.xml a9s/common/xpl/omnibook2idml.xpl
```

or with `make`:

```bash
make conversion IN_FILE=../content/ELS/BRDA/172019/xml/BRDA172019_print.xml
```

For the `make` invocation, debugging data will be stored in `../content/ELS/BRDA/172019/debug`. For the `calabash.sh` invocation, you can specify `debug=yes debug-dir-uri=file:/my/debug/dir` at the end of the command line above. Instead of `calabash/calabash.sh` which runs on Linux, Mac OS, and Cygwin, you can also use `calabash/calabash.bat` which runs on Windows, with or without Cygwin. Other invocations, for example from a Java program, need to be implemented according to what the front-end script `calabash.sh` does.
