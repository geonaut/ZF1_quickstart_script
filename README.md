# ZF1_quickstart_script
A bash script for automatic creation of the ZF1 quickstart site.

Running this script will create a ZF1 QuickStart site, based on the ZF1 quickstart tutorial.

##Requirements:

* ZF1 command line application
* Apache2 (if you want the vhost)

##Main steps:

1. (Optional) Create a vhost
1. Create a zf project
1. Enable zf layout
1. Setup the bootstrap to look for the layout and the xhtml DocType
1. Create a model and a database adapter
1. Create and populate a sqlite database
1. Add in the controllers and layouts from the examples
