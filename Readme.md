Parser for Skype Logs
=====================

The find function of newer Skype clients does not properly search the history.
Microsoft provide a json export of all chat logs on the
[Skype homepage](https://secure.skype.com/en/data-export). This is a crude
parser that converts the log into a human readable format.

Building
========

To compile the project, just use

    dune build src/skypelogs.exe

Running
=======

The tool reads from stdin and writes to stdout.


Known Issues
============

* The user names have some internal data attached
* The message content is currently printed as is (the messsage type is RichText
  but it looks like HTML)
* Only the minimum number of fields that are necessary for writing a log
  are parsed
