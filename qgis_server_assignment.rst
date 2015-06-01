Introduction
============

In this assignment we will publish data on web using QGIS. We will
use QGIS Desktop for preparing data for QGIS Server. Then we will
look at the result using QGIS Web Client, Leaflet web page, and
pure WMS request. The section OSGeo-Live example shows a simple
usage of QGIS Server when everything is configured. The OSGeo-Live should
be used for this example. The other sections describe everything in
detail including the configuration of QGIS Web Client. Unfortunately,
QGIS Web Client example does not work on the OSGeo-Live 7.0 because
it has too old QGIS version.


OSGeo-Live example
==================

In OSGeo-Live there is a running QGIS Server and also some examples
which uses QGIS Web Client which are described at
http://localhost/en/quickstart/qgis_mapserver_quickstart.html.
Here we will create a new QGIS project, publish it using QGIS Server
and display the result using WMS.


Create a new QGIS project
-------------------------

* Open QGIS using system menu on the top: *Geospatial* > *Desktop GIS* > *QGIS*.

* Click *Layer* > *Add Vector Layer...*.

* Browse to dataset ``/home/user/data/natural_earth2/ne_10m_admin_0_countries.shp``.

* Press *Open*. (You should see all world countries now.)

* Save the project with *File* > *Save Project*.

* Use file name ``/home/user/world.qgs`` and press *Save*.


Get an image using WMS
----------------------

Now open the URL of WMS service::

    http://localhost/cgi-bin/qgis_mapserv?map=/home/user/world.qgs&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=-91.901820,-180.000000,83.633800,180.000000&CRS=EPSG:4326&WIDTH=722&HEIGHT=352&LAYERS=ne_10m_admin_0_countries&STYLES=default&FORMAT=image/png&DPI=96&TRANSPARENT=true

You should see all world countries rendered by QGIS Server as an PNG
image.

You can find this URL also in the OSGeo-Live documentation placed
directly in the OSGeo-Live virtual machine::

    http://localhost/en/quickstart/qgis_mapserver_quickstart.html

The page contains similar example as described here and is available
online at http://live.osgeo.org/en/quickstart/qgis_mapserver_quickstart.html.


Preparing project in QGIS
=========================

This section describes adding layers to QGIS (QGIS Desktop) and
preparing QGIS project for publishing using QGIS Server.

You can use your data but here we will use QGIS sample data available at
http://download.osgeo.org/qgis/data/qgis_sample_data.zip or
alternatively through
http://www.qgis.org/en/docs/user_manual/introduction/getting_started.html#sample-data.

Use *Layer* > *Add Raster Layer* or *Layer* > *Add Vector Layer* to
add the following files from QGIS sample data directory (where you
downloaded and uncompressed the data)::

    raster/SR_50M_alaska_nad.tif
    shapefiles/alaska.shp
    shapefiles/grassland.shp

The ideal order is with the raster at the top and grassland vector at
the bottom. We can change the colors of layers, e.g. grassland can be
green. This is done by the double click on the layer and setting
properties in the *Layer Properties* dialog (in the *Style* tab).

It is good to know that the data are in NAD27/Alaska Albers (EPSG:2964)
projection. We will not use it but the project extent is specified
in this projection.

We can now go to *File* > *Project Properties* then to *General*
and set *Save paths* to *absolute* which is good in case when we want to
copy the project file from our user space to the server space but not to
copy the data itself.

Then, still in *Project Properties*, go to *OWS Server* and set some of
*Service capabilities* and also check *Advertise extent* in
*WMS capabilities*.


Using QGIS Server
=================

This section describes how to publish existing QGIS project using
QGIS Server.

Preparing the data for the server
---------------------------------

Create a new directory (here ``alaska``) in ``cgi-bin`` directory
(e.g. ``/usr/lib/cgi-bin/`` on Ubuntu) for the project
and copy there ``qgis_mapserv.fcgi`` and ``wms_metadata.xml`` files::

    sudo mkdir /usr/lib/cgi-bin/alaska
    sudo cp /usr/lib/cgi-bin/qgis_mapserv.fcgi /usr/lib/cgi-bin/alaska
    sudo cp /usr/lib/cgi-bin/wms_metadata.xml /usr/lib/cgi-bin/alaska

You may want to edit some values in ``wms_metadata.xml`` file. But for
our example it is not necessary.

Then copy also the QGIS project file which you saved in QGIS Desktop::

    sudo cp ~/qgis-projects/alaska.qgs /usr/lib/cgi-bin/alaska

You need to copy it whenever you changed the file. Alternatively, you
can create a symbolic link. You don't need to copy the data if the
project is using absolute paths (can be changed in project properties).


Getting data from the server
----------------------------

Check that server works and your project is correct using
``GetCapabilities`` request::

    http://localhost/cgi-bin/alaska/qgis_mapserv.fcgi?request=GetCapabilities&SERVICE=WMS&VERSION=1.1.1

You can also do the WMS ``GetMap`` request::

    http://localhost/cgi-bin/alaska/qgis_mapserv.fcgi?service=WMS&request=GetMap&version=1.1.1&layers=alaska&styles=&format=image/png&transparent=true&height=256&width=256&srs=EPSG:2964&bbox=-7876621.70568871777504683,-985954.85252842528279871,8006823.47062830720096827,9525393.15944263152778149

The maximum coordinates extent we can use is in the ``GetCapabilities`` response.


Alternative way of specifying the QGIS project
----------------------------------------------

Alternatively, we don't need to copy the QGIS project file.
It is enough just to specify the ``map`` parameter in the request::

    http://localhost/cgi-bin/qgis_mapserv.fcgi?map=/usr/lib/cgi-bin/alaska/alaska.qgs&request=GetCapabilities&SERVICE=WMS&VERSION=1.3.0


Explanation of the WMS URL request
----------------------------------

The first part is the address of QGIS server::

    http://localhost/cgi-bin/qgis_mapserv.fcgi
    http://localhost/cgi-bin/qgis_mapserv

The adress or the suffix can differ depending on the installation.

The value of ``map`` property specifies where is the QGIS project file
placed on the hard drive::

    map=/home/user/world.qgs

The other properties are standard parts of WMS request. You can change
the size of the image, coordinate reference system, displayed area
(bounding box) and image format in examples provided in this document.


Links
-----

* Official documentation, http://www.qgis.org/en/docs/user_manual/working_with_ogc/ogc_server_support.html
* Original QGIS Server site, http://karlinapp.ethz.ch/qgis_wms/index.html
* QGIS Server tutorial, http://hub.qgis.org/projects/quantum-gis/wiki/QGIS_Server_Tutorial
* QGIS Server and QGIS Web Client examples, http://gis.uster.ch/

Because we are using the nightly builds of QGIS Server it is advisable
to have links to issue tracking available:

* http://www.qgis.org/en/site/getinvolved/development/index.html#bugs-features-and-issues
* http://hub.qgis.org/wiki/quantum-gis/Bugreports
* http://hub.qgis.org/projects/quantum-gis/issues
* http://lists.osgeo.org/mailman/listinfo/qgis-developer


QGIS Web Client
===============

This section describes how to setup a QGIS Web Client web page. Commands
provided here applies to Ubuntu.

Download and uncompress the latest QGIS Web Client::

    wget https://github.com/qgis/QGIS-Web-Client/archive/master.zip --output-file=QGIS-Web-Client.zip
    unzip QGIS-Web-Client.zip

Alternatively, use https://github.com/qgis/QGIS-Web-Client and download
a ZIP file there and than uncompress in file manager.

Go to the newly created ``QGIS-Web-Client`` directory and use some file
templates to configure the web page (here we just copy the prepared
templates)::

    cd QGIS-Web-Client
    cp apache-conf/qgis-web-client.conf.tmpl apache-conf/qgis-web-client.conf
    cp site/js/GlobalOptions.js.templ-3857 site/js/GlobalOptions.js
    ln -s -f /usr/lib/cgi-bin/qgis_mapserv.fcgi cgi-bin/qgis_mapserv.fcgi

You can do some other changes to the web site but we will just copy files
to the server space::

    cd ..
    sudo cp -r QGIS-Web-Client/ /var/www/

Maybe, you need to enable Apache module and Apache site using the
following commands::

    cd /etc/apache2/sites-available/
    sudo ln -s /var/www/QGIS-Web-Client/apache-conf/qgis-web-client.conf
    sudo a2enmod rewrite
    sudo a2ensite qgis-web-client.conf
    sudo /etc/init.d/apache2 reload

And now assuming that we have the QGIS project file ``alaska.qgs`` in
``/usr/lib/cgi-bin/alaska``, we can initialize QGIS client using the
project file:

::

    http://localhost/QGIS-Web-Client/site/qgiswebclient.html?map=/usr/lib/cgi-bin/alaska/alaska.qgs

If you have some problems, you may want to see Apache log, e.g. using
``tail`` command to get the last messages::

    tail /var/log/apache2/error.log

The repository for QGIS Web Client is available at
https://github.com/qgis/QGIS-Web-Client and the documentation
at https://github.com/qgis/QGIS-Web-Client/blob/master/README.pdf?raw=true.


QGIS Server and Leaflet
=======================

This section describes how to visualize data from QGIS Server using
Leaflet and WMS.

We need the Leaflet web page sample file ``leaflet-web-page.html``
which we will modify.

At first we need to create a WMS layer. It is necessary to specify
the URL of the server. Depending on how you added your project to server
it would be ``cgi-bin/alaska/qgis_mapserv.fcgi`` or
``cgi-bin/alaska/qgis_mapserv.fcgi`` with
``?map=/usr/lib/cgi-bin/alaska/alaska.qgs``. Than we need to specify
layers, format (we choose PNG) and whether we want image to be
transparent. Usually, we also need to specify attribution for legal
reasons.

::

    var wmsLayer = L.tileLayer.wms("http://localhost/cgi-bin/alaska/qgis_mapserv.fcgi",
        {
            layers: 'alaska,grassland',
            format: 'image/png',
            transparent: true,
            attribution: "Alaska data ©2013 QGIS sample dataset"
        }
    );

This will create a one Leaflet WMS layer for provided layers ``alaska``
and ``grassland``. Alternatively, we can create one Leaflet WMS layer
for each provided layer by specifying the values of ``layers`` option.
The layers we provided are ``alaska``, ``grassland``, and ``SR_50M_alaska_nad``.
The documentation for Leaflet WMS Layer class can be found at
http://leafletjs.com/reference.html#tilelayer-wms.

To show the layer at the beginning, we need to add it to the ``map``
object initial layers::

    var map = L.map('map', {
        // ...
        layers: [osmLayer, wmsLayer]
    });

To allow user to control whether layer is visible we will add the layer
to overlay layers and add the list to layer ``control`` object::

    // var baseLayers = ...

    var overlayLayers = {
        "WMS QGIS Layer": wmsLayer
    };

    var layerControl = L.control.layers(baseLayers, overlayLayers);

It is better if the map is zoomed to the area of the map, not perfect
but simple way is to view ``GetCapabilities`` using URL similar to this::

    http://localhost/cgi-bin/qgis_mapserv.fcgi?map=/usr/lib/cgi-bin/alaska/alaska.qgs&request=GetCapabilities&SERVICE=WMS&VERSION=1.1.1

Then, in the output XML, find (geographical) bounding box of the layer.

::

    <Layer queryable="1">
     <Name>alaska</Name>
     <Title>alaska</Title>
     <EX_GeographicBoundingBox>
      <westBoundLongitude>-179.729</westBoundLongitude>
      <eastBoundLongitude>178.95</eastBoundLongitude>
      <southBoundLatitude>42.17</southBoundLatitude>
      <northBoundLatitude>76.0773</northBoundLatitude>
     </EX_GeographicBoundingBox>
     <BoundingBox CRS="EPSG:2964" maxx="8.00682e+06" minx="-7.87662e+06" maxy="9.52539e+06" miny="-985955"/>
    </Layer>

Then we can set the option values of the ``map`` object, namely
``center`` and ``zoom``, to values derived or guessed from geographical
bounding box.

If we want this example to work with OSGeo-Live example with world map,
we need to set the WMS server URL to::

    http://localhost/cgi-bin/qgis_mapserv?map=/home/user/world.qgs

The only provided layer is ``ne_10m_admin_0_countries``.

An alternative Leaflet and QGIS Server example is available at
http://anitagraser.com/category/gis/qgis-server/.

There is also an OpenLayers example in the OSGeo-Live documentation at
http://live.osgeo.org/en/quickstart/openlayers_quickstart.html.


Appendix: Download and run OSGeo-Live
=====================================

This section describes how to run OSGeo-Live operating system which
allows to try almost all free and open source GIS software. More
information are available at http://live.osgeo.org/.

You will need at least 10 GB but better 20 GB of free space on your hard
drive (note that you cannot use FAT32 file system).

Download OSGeo-Live virtual machine from
http://live.osgeo.org/en/download.html. It is a file
``osgeo-live-vm-7.0.7z`` (for version 7.0) which has approximately 3 GB.

Uncompress the file. It is in 7z format, for example on Ubuntu you need
to have ``p7zip-full`` package installed and than in Nautilus file
browser you use left mouse button and *Extract here*, on MS Windows, you
need to download 7-zip software from http://www.7-zip.org/, the next
step should be similar to Ubuntu. Note that uncompressing will take some
time. The uncompressed file ``osgeo-live-vm-7.0.vmdk`` will have
approximately 10 GB.

To run the virtual machine, you need to have VirtualBox software,
on Ubuntu, you need to install package ``virtualbox`` or
``virtualbox-ose`` and on MS Windows, you need to download the software
from https://www.virtualbox.org/.

Now start the VirtualBox application and click on the *New* button to
create a new virtual machine, and then click *Next*.

Enter a name such as OSGeo-Live, and choose Linux as the
“Operating system”, and Ubuntu as the “Version”.

In the next screen set the memory to 1024 MB (or more if your host
computer has more than 4GB).

Continue to the next screen and choose *Use existing hard disk*. Now
click on the button (a folder icon) to browse to where you saved
the ``osgeo-live-vm-6.0.vmdk`` file. Select this file, press *Next* and
*Create*.

Once the virtual machine is created, click on the Settings button.
In the *General* section, go to the *Advanced* tab, and click to select
*Show at top of screen* for the Mini toolbar.

Go to the *Display* section and increase video memory to 32 or 64 MB.

Now boot the virtual machine by clicking the *Start* (green arrow)
button in the main Virtualbox window.

You can see the detailed guide including screenshots at:
http://live.osgeo.org/en/quickstart/virtualization_quickstart.html

Alternatively, you can boot or install (non-virtually) OSGeo-Live from
DVD or USB memory stick.


Appendix: QGIS Cloud
====================

QGIS Cloud is not an cloud application we can install, it is
a service provided by certain company (Sourcepole AG). They offer
free plans (free as in free beer) which we can try and use to some
certain extent.

The system consists of a QGIS plugin which allows us to upload our
QGIS project including data into their cloud and their cloud which
allows us to view the uploaded data using QGIS Web Client (and QGIS Server
behind it).

How to use the service is described at
http://www.qgiscloud.com/en/pages/quickstart.
The basic information are available at the service web site and the
description from the technical point is in FOSS4G
*QGIS Server, QGIS Web Client And QGIS Cloud* presentation abstract
available at http://2013.foss4g.org/conf/programme/presentations/137/.

Information about pricing is available at
http://www.qgiscloud.com/en/pages/plans.

Examples of usage are available at
http://www.qgiscloud.com/klauswiese/Caserios_PNLT and
http://www.qgiscloud.com/esevens/wms_dossierinfo.


Appendix: Installing latest QGIS on Ubuntu
==========================================

This section provides some pointers how to install latest QGIS including
QGIS Server on Ubuntu.

Add a key to identify the identity the repository using command line::

    gpg --keyserver keyserver.ubuntu.com --recv 47765B75
    gpg --export --armor 47765B75 | sudo apt-key add -

Or use the GUI way which is described at
http://askubuntu.com/questions/13065/how-do-i-fix-the-gpg-error-no-pubkey.

If you don't do it you will get something similar to::

    ...The following signatures couldn't be verified...

When installing on Ubuntu 12.04, add these line to you repository sources::

    deb http://qgis.org/ubuntugis-nightly precise main
    deb-src http://qgis.org/ubuntugis-nightly precise main

You may need to add also::

    deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu precise main

Then run::

    sudo apt-get update
    sudo apt-get install qgis python-qgis qgis-mapserver
    sudo apt-get install libapache2-mod-fcgid

Restart Apache::

    sudo /etc/init.d/apache2 restart

The installation is described in QGIS official sources at
http://www.qgis.org/en/site/forusers/alldownloads.html but a good
description is available also at
http://anitagraser.com/2012/03/30/qgis-server-on-ubuntu-step-by-step/
for Ubuntu and at
http://anitagraser.com/2012/04/06/qgis-server-on-windows7-step-by-step/
for MS Windows.


Appendix: Differences between WMS 1.1.1 a and WMS 1.3.0
=======================================================

QGIS Server supports both WMS 1.1.1 a and WMS 1.3.0 and when trying the
functionality we can see requests in both versions of WMS. There are
some differences which is better to describe.

Coordinate reference system key
-------------------------------

In the ``GetMap`` request the ``srs`` WMS 1.1.1 key is renamed to
``crs`` in WMS 1.3.0.

Axis Ordering
-------------

The WMS 1.3.0 specification mandates that the axis ordering for
geographic coordinate systems defined in the EPSG database be
latitude-longitude, or y-x. This requires that the coordinate order in
the BBOX parameter be reversed for SRS values which are geographic
coordinate systems.

For example, consider the WMS 1.1.1 request using the WGS84 SRS
(EPSG:4326)::

    geoserver/wms?VERSION=1.1.1&REQUEST=GetMap&SRS=epsg:4326&BBOX=-180,-90.180,90&...

The equivalent WMS 1.3 request is::

    geoserver/wms?VERSION=1.1.1&REQUEST=GetMap&CRS=epsg:4326&BBOX=-90,-180,90,180&...

This is contrary to the fact that most spatial data is usually in
longitude-latitude, or x-y.

However, for most projected coordinate systems, EPSG still defines the
axis order as x followed by y (x-y), so nothing changes between WMS 1.1.1
and WMS 1.3.0 in those cases. For instance, with EPSG:3857 (Google
Mercator projection in meters), the BBOX coordinate order remains the
same for both WMS 1.1.1 and WMS 1.3.0::

      BBOX=xmin,ymin,xmax,ymax

We can see some criticism to these changes at some places, e.g. at
http://dmorissette.blogspot.com/2012/12/dont-upgrade-to-wms-130-unless-you.html.


License
=======

This work by Vaclav Petras is licensed under a Creative Commons
Attribution-ShareAlike 4.0 International License,
http://creativecommons.org/licenses/by-sa/4.0/.

The appendix “Download and run OSGeo-Live” includes content from
the “OSGeo-Live Quickstart for Running in a Virtual Machine” created by
Micha Silver and Cameron Shorter under
the Creative Commons Attribution-ShareAlike 3.0 Unported licence,
http://creativecommons.org/licenses/by-sa/3.0/ available from
the OSGeo-Live project,
http://live.osgeo.org/en/quickstart/gvsig_quickstart.html, and
downloaded on 2 November 2013.

The section “OSGeo-Live example” includes content from
the “QGIS Server Quickstart” created by Pirmin Kalberer under
the Creative Commons Attribution-ShareAlike 3.0 Unported licence,
http://creativecommons.org/licenses/by-sa/3.0/ available from
the OSGeo-Live project,
http://live.osgeo.org/en/quickstart/gvsig_quickstart.html, and
downloaded on 2 November 2013.

The appendix “Differences between WMS 1.1.1 a and WMS 1.3.0” includes
content from the “GeoServer 2.4.x User Manual” created by
OpenPlans under
the Creative Commons Attribution 3.0 Unported licence,
http://creativecommons.org/licenses/by/3.0/ available from
the GeoSever project,
http://docs.geoserver.org/stable/en/user/services/wms/basics.html, and
downloaded on 2 November 2013.

