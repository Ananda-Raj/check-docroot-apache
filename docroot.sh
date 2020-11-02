#!/bin/bash

# Script to check Document Root of domains
# Author: Ananda Raj
# Date: 13 Oct 2020

DOMAIN=$1
CP_HTTP_CONF=/usr/local/apache/conf/httpd.conf
CWP_HTTP_CONF=/usr/local/apache/conf.d/vhosts
APACHE_CONF=/etc/apache2/sites-enabled/
HTTPD_CONF=/etc/httpd/conf/httpd.conf


##For cPanel
if [ -f "/usr/local/cpanel/cpanel" ]; then
	{
        echo "CPANEL VERSION: `/usr/local/cpanel/cpanel -V`"
	if [ -z $DOMAIN ]; then
		read -p "Enter domain name: " DOMAIN
		if [ -z $DOMAIN ]; then
			echo "ERROR: Required Data Missing!"
		exit 1
		fi
	fi
	
	DOC_ROOT=`grep -A2 " $DOMAIN" $CP_HTTP_CONF | grep DocumentRoot | awk {'print $2'} | awk 'NR == 1'`

	if [ "$DOC_ROOT" ]; then
		echo "Document Root of $DOMAIN: $DOC_ROOT"
	else
		echo "ERROR: Domain $DOMAIN not found in this server!"
	fi
	}


##For CWP
elif [ -f "/usr/local/cwpsrv/htdocs/resources/admin/include/version.php" ]; then
	{
        echo "CWP VERSION: `grep version /usr/local/cwpsrv/htdocs/resources/admin/include/version.php | awk '{print $NF}'| tr -d '"|;'`"
	if [ -z $DOMAIN ];
		then
		read -p "Enter domain name: " DOMAIN;
		if [ -z $DOMAIN ];
		        then
		        echo "ERROR: Required Data Missing!";
		exit 1;
		fi
	fi

	DOC_ROOT=`grep DocumentRoot $CWP_HTTP_CONF/$DOMAIN.conf 2> /dev/null | awk '{print $2}'`;
	
	if [ "$DOC_ROOT" ]; then
	        echo "Document Root of $DOMAIN: $DOC_ROOT";
	else
	        echo "ERROR: Domain $DOMAIN not found in this server!";
	fi
	}

##For Apache2
elif [ -d "/etc/apache2/sites-enabled" ]; then
        {
        echo "`apache2 -v`"
	if [ -z $DOMAIN ]; then
                read -p "Enter domain name: " DOMAIN
                if [ -z $DOMAIN ]; then
                        echo "ERROR: Required Data Missing!"
                exit 1
                fi
        fi

	DOC_ROOT=`grep " $DOMAIN" $APACHE_CONF/* -C3 | grep DocumentRoot | awk '{print $NF}'| tr -d '"|;' | awk 'NR == 1'`
        if [ "$DOC_ROOT" ]; then
                echo "Document Root of $DOMAIN: $DOC_ROOT"
        else
                echo "ERROR: Domain $DOMAIN not found in this server!"
        fi
        }

##For httpd
elif [ -f "/etc/httpd/conf/httpd.conf" ]; then
        {
        echo "`apachectl -v`"
	if [ -z $DOMAIN ]; then
                read -p "Enter domain name: " DOMAIN
                if [ -z $DOMAIN ]; then
                        echo "ERROR: Required Data Missing!"
                exit 1
                fi
        fi

	DOC_ROOT=`grep $DOMAIN $HTTPD_CONF -C3 | grep DocumentRoot | awk '{print $NF}'| tr -d '"|;' | awk 'NR == 1'`
        if [ "$DOC_ROOT" ]; then
                echo "Document Root of $DOMAIN: $DOC_ROOT"
        else
                echo "ERROR: Domain $DOMAIN not found in this server!"
        fi
        }

##Others
else
        echo -e "\nCouldn't Find any Control Panel / Apache\n"
fi
