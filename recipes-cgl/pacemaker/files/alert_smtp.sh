#!/bin/sh
#
# Copyright 2016-2017 the Pacemaker project contributors
#
# The version control history for this file may have further details.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
##############################################################################
#
# Sample configuration (cib fragment in xml notation)
# ================================
# <configuration>
#   <alerts>
#     <alert id="smtp_alert" path="/path/to/alert_smtp">
#       <instance_attributes id="config_for_alert_smtp">
#         <nvpair id="cluster_name" name="cluster_name" value=""/>
#         <nvpair id="email_client" name="email_client" value=""/>
#         <nvpair id="email_sender" name="email_sender" value=""/>
#       </instance_attributes>
#       <recipient id="smtp_destination" value="admin@example.com"/>
#     </alert>
#   </alerts>
# </configuration>

email_client_default="mailx"
email_sender_default="hacluster@localhost"
email_recipient_default="root@localhost"

: ${email_client=${email_client_default}}
: ${email_sender=${email_sender_default}}
email_recipient="${CRM_alert_recipient-${email_recipient_default}}"

node_name=`uname -n`
cluster_name=`crm_attribute --query -n cluster-name -q`
email_body=`env | grep CRM_alert_`

if [ ! -z "${email_sender##*@*}" ]; then
    email_sender="${email_sender}@${node_name}"
fi

if [ ! -z "${email_recipient##*@*}" ]; then
    email_recipient="${email_recipient}@${node_name}"
fi

if [ -z ${CRM_alert_version} ]; then
    email_subject="Pacemaker version 1.1.15 or later is required for alerts"
else
    case ${CRM_alert_kind} in
        node)
            email_subject="${CRM_alert_timestamp} ${cluster_name}: Node '${CRM_alert_node}' is now '${CRM_alert_desc}'"
            ;;
        fencing)
            email_subject="${CRM_alert_timestamp} ${cluster_name}: Fencing ${CRM_alert_desc}"
            ;;
        resource)
            if [ ${CRM_alert_interval} = "0" ]; then
                CRM_alert_interval=""
            else
                CRM_alert_interval=" (${CRM_alert_interval})"
            fi

            if [ ${CRM_alert_target_rc} = "0" ]; then
                CRM_alert_target_rc=""
            else
                CRM_alert_target_rc=" (target: ${CRM_alert_target_rc})"
            fi

            case ${CRM_alert_desc} in
                Cancelled) ;;
                *)
                    email_subject="${CRM_alert_timestamp} ${cluster_name}: Resource operation '${CRM_alert_task}${CRM_alert_interval}' for '${CRM_alert_rsc}' on '${CRM_alert_node}': ${CRM_alert_desc}${CRM_alert_target_rc}"
                    ;;
            esac
            ;;
        attribute)
            #
            email_subject="${CRM_alert_timestamp} ${cluster_name}: The '${CRM_alert_attribute_name}' attribute of the '${CRM_alert_node}' node was updated in '${CRM_alert_attribute_value}'"
            ;;
        *)
            email_subject="${CRM_alert_timestamp} ${cluster_name}: Unhandled $CRM_alert_kind alert"
            ;;

    esac
fi

if [ ! -z "${email_subject}" ]; then
    case $email_client in
        # This sample script supports only sendmail for sending the email.
	# Support for additional senders can easily be added by adding
	# new cases here.
        mailx)
            mailx -s "${email_subject}" ${email_recipient} <<__EOF__
${email_body}
__EOF__
            ;;
        sendmail)
            sendmail -t -r "${email_sender}" <<__EOF__
From: ${email_sender}
To: ${email_recipient}
Return-Path: ${email_sender}
Subject: ${email_subject}

${email_body}
__EOF__
            ;;
        *)
            ;;
    esac
fi
