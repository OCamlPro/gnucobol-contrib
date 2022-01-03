Welcome to the GnuCOBOL contributions tree
==========================================

This is a free software COBOL source code repository.

    As a matter of principle, the programs we host here must be free
    software; each must carry a free license.  To avoid uncertainty,
    each program should state its licensing with clear license notices
    in the source files.  We limit our hosting to GPL-compatible
    licenses so as not to interfere with linking with other programs
    that are covered by the GNU GPL.

See https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
for a list of licenses.

Enjoy exploring.

More links
--------------------
If you want to contribute here or have a question about existing contributions
leave us a message via SourceForge, forum "contributions" at
https://sourceforge.net/p/gnucobol/discussion/contrib/

A ticket system for bug reports and feature or support requests can be found at
https://sourceforge.net/p/gnucobol/_list/tickets

*Some* of the contributions found here have additional download files at
https://sourceforge.net/projects/gnucobol/files/contrib/

Making contributions
--------------------

The main source code repositories for GnuCOBOL on SourceForge use Subversion,
or `svn` for short.  To take part as a contributing member you will need some
form of Subversion system.  There is the main command line version and quite a
few graphical front ends for Subversion.  TortoiseSVN comes recommended.

See http://subversion.apache.org/ for all the details.

tl;dr
-----
(too long; didn't read)

Install an svn client, then

    svn checkout --username=sfuser svn+ssh://sfuser@svn.code.sf.net/p/gnucobol/contrib/trunk gnucobol-contrib

*where sfuser is your SourceForge userid, and gnucobol-contrib is your preferred local
repository directory*

Create a new working directory under `<gnucobol-contrib>/samples` (for instance
`localproject`) *or use the name assigned by Simon.  He'll drop you a note when
you get write permissions on where the best place in the structure to place
your contribution, and the sub-directory may already be in place when you do
your initial checkout*.

    svn add gnucobol-contrib/samples/<localproject>

Work away at the next big thing, adding any newfiles with

    svn add gnucobol-contrib/samples/<localproject>/<localfile>

*It might be `tools` instead of `samples` depending on the type of
contribution.*

Then, when ready to share, update to current, just in case

    svn update
    svn status

to see if you have missed marking any files for shared revision control.

Then make the commitment.

    svn commit -m "commit message"

Keep up to date with

    svn update

when your current working directory is `<gnucobol-contrib>`.

Still reading
-------------
(more details)

For most GNU/Linux systems, all you will need to do is install the package.

    sudo apt install subversion

or

    sudo yum install subversion

other systems will use different package commands, but all are similar and the
package is almost always called `subversion`.

For GNU/Linux, and GnuCOBOL programming in general, the command line is
recommended.

For a graphical front-end, in particular Windows, TortoiseSVN is recommended,
but there are other options as well.

For a GNU/Linux gui, there is a few choices, `kdesvn` if your desktop is KDE
based, or NautilusSVN for those that use Nautilus with GNOME.  A quick bing on
google for "SVN client" is likely the easiest way of finding a client program
that suits your particular tastes and work habits.

Anyone can checkout the tree for local use, this is what it is being built for.

Contributors will need to have write permissions provided by the GnuCOBOL
management team, Simon Sobisch is in charge of the keys for this.  Drop a note
on the GnuCOBOL forums at

https://sourceforge.net/p/gnucobol/discussion/contrib

and we'll get you all setup to contribute.

Licensing
---------
GnuCOBOL is a GNU free software project.  The compiler is licensed under the
GPL version 3 (or greater), with the libcob runtime licensed under the LGPL 3
or greater.

The compiler proper has had legal documents signed by all contributing
developers to place copyrights under the ownership of the Free Software
Foundation.

While the `contrib/` tree has less obligation (you will keep copyrights) the
project still needs to use GPL compatible or other free software licensing for
these contributions.  Contributions must have an explicit licensing notice to
be accepted.  We recommend the GNU General Public License, GPL or LGPL version
3 (or greater), but will accept other licensing, at author discretion.  *It's
your software source, and you are free to choose, but the choice still needs to
be free software compatible.  The whole point of the `contrib/` tree is the
sharing of free COBOL software for use with GnuCOBOL or other COBOL compiler
systems.*

Vetting
-------
Each contribution will be vetted by other members of the project.  Any security
concerns or other issues raised must be immediately addressed by the
contributing author, or the entry may be removed without warning, and without
prejudice. 
  
Subversion, svn
---------------

`svn` is the main shell command.

Most people will not need to worry about `svnadmin` for contributing, as the
repository is already setup and well managed. 

### Help

`svn help` provides detailed help on all of the svn sub-commands, and there are
quite a few, but for normal day to day operations, most users will get by
knowing three or four main svn keywords.

Workflow
--------

First you need a working directory.  That starts with a checkout of the
existing GnuCOBOL contrib/ tree.

SourceForge helps out here, as it gives the command to use for both ReadOnly
and ReadWrite permissions.

Visit https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/ and near the top
middle of the web page there is options that show RW RO and HTTP command
options.  Copy'n'paste a RO or RW command into a terminal to get a working
copy.  Or follow the sequence required for your graphical client.

For example:

    svn checkout svn://svn.code.sf.net/p/gnucobol/contrib/ gnucobol-contrib

is the normal ReadOnly command that is shown.  This will create a working copy
under your current working directory called `gnucobol-contrib`.  You should
change that last part to suit tastes.

This author uses

    prompt$ cd ~/wip/contrib

to hold a local working copy of the contributions tree, but that is up to you,
and has no effect on anyone outside of your local machine.  In line with SVN
common practice, there are then sub-directories for

    branches
    tags
    trunk

Most of the work for contributions occurs in `trunk/`.

`trunk/` is divided up (currently) with the following top levels at the time of writing

    copyfiles  esql  ipc  README  samples  tools

And most of the work here occurs in `samples/` and `tools/`.  For most
contributions, it is usually self evident which sub-directory to start in, but
talk with Simon and discuss any issues if the contribution doesn't seem to fit
in with the current tree structure.

Within `tools/` or `samples/` each developer will create a new working
directory that reflects the name of the particular entry.  For example,
`contrib/trunk/samples/tools/prothsearch/` for a set of COBOL sources that
support Proth Prime searches.  Within `prothsearch/`, Lazlo created a
`readme.txt` that shows up on the SourceForge web pages all nicely formatted,
along with a sample `Makefile` and `win_compile.bat` to demonstrate the
tectonics for building the program.  And the sources, as `prothsearch.cob`,
`prothtest.cob` and a supporting `smallprimes.cpy` copy book.

Within any particular working directory, a developer is free to choose a
comfortable structure, but there should be a readme along with some
instructions on how to go about building the software.

After you have the structure in place, `svn` needs to be told that you wish to
track changes and to share.  From `contrib/trunk/samples`

    svn add prothsearch

would add all of the files in Lazlo's contribution, as add is recursive.  You
may wish to pick and choose each file separately, if you have temporary build
files that don't need or should not be under revision control, .o compiler
outputs, for instance.  But try and not miss any files, or they won't be
distributed on check-in and people that pull from the repository won't see the
files or be able to properly build your contribution. 

To keep in synch, use

    svn update

This command pulls any changes in the master repository into your local repo.

Please note that SVN is a distributed revision control system.  That means
there are three copies involved at any given time.  The master repository
stored on SourceForge, a local repository, and your working copy.  The local
repository is usally hidden in '.svn' subdirectories and any working files stay
local until `svn` is told to check them in for sharing with the master
repository.

Your local working copy is never overwritten by `svn` until told to do so.

If you have made edits, and then do `svn update`, your current working files
will not be overwritten by the copy held in the master repository.  Nor will
anyone else see local changes until an `svn commit` occurs.

As each developer usually has their own sub-directory, there is very little
chance of conflicting edits and very little need to worry about the
complexities involved with `svn merge`.

But please note: if you make local changes to another developer's files, and
you have write permissions, when you do an `svn commit`, it will also commit
the changes you made to the other developer's files.  Be careful when making
local customizations, and if there is ever an accidental commit, you'll need
to read up on `svn revert`.

Thanks
------
Many thanks for contributing. Each entry, large or small, makes GnuCOBOL a
better system.
