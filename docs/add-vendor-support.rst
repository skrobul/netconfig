Add Vendor Support
==================

Getting Started
---------------

Currently as of version 1.0b, NetConfig only support Cisco routers, switches, and firewalls, running IOS, IOS-XE, NX-OS, or ASA's.  However in version 1.1b, support was added for different vendors and different vendor model network devices.

This guide intends to document how to create a base device class for a vendor, as well as individual device model classes, for support with integrating into NetConfig.  Any new device classes that work successfully and are tested thoroughly may be submitted as a Pull Request for official integration into the overall project.

Create Base Devive Class
------------------------

The base device class is used for different vendors.  Currently, the only existing base device class is for Cisco, titled "cisco_base_device.py".  In this example, we will create a new base device class for vendor "Acme".

Before creating any files, make sure to SSH in to the NetConfig server as user 'netconfig', or switch over to the user 'netconfig' once logging in.

.. code-block:: text

    su - netconfig

File Location
^^^^^^^^^^^^^

In this example, the file is located in ~/netconfig/app/device_classes/device_definitions/acme_base_device.py.

.. code-block:: text

    cd ~/netconfig/app/device_classes/device_definitions
    touch acme_base_device.py
    vi acme_base_device.py

The basic structure of this file is as follows:

.. code-block:: python

    from base_device import BaseDevice
    
    class AcmeBaseDevice(BaseDevice):
        # functions go here

The file has a few base functions that are required by the overall NetConfig program.  As NetConfig grows its feature set, more required functions may be added, and will need to be added/updated in here as necessary.

All functions in here are expected to work with any/all network devices made by this vendor.  Model specific functions will go in the individual device model classes, explained at the end of this file.

Required Functions
""""""""""""""""""

These functions and their specific names are required for NetConfig, including the required inputs and expected outputs.  How they process the inputs in order to return the required output varies for each specific network vendor.

.. code-block:: python

    # Input: None required
    # Purpose: Provide the command used to enter a configuration mode in the device
    # Output:
    #    command (string) - Outputs the command used to enter configuration mode for all vendor devices
    
    def get_cmd_enter_configuration_mode(self):
        # Function logic goes here
        return commandStr

    # Input: None required
    # Purpose: Provide the command used to exit the configuration mode in the device
    # Output:
    #    command (string) - Outputs the command used to exit configuration mode for all vendor devices
    
    def get_cmd_exit_configuration_mode(self):
        # Function logic goes here
        return commandStr

    # Input: None required
    # Purpose: Provide the command used to enable a specific interface
    # Output:
    #    commandStr (string) - Outputs the command used to enable / activate / unshut / bring online an interface for all vendor devices
    # Output Type: String
    
    def get_cmd_enable_interface(self):
        # Function logic goes here
        return commandStr

    # Input: None required
    # Purpose: Provide the command used to disable a specific interface
    # Output:
    #    commandStr (string) - Outputs the command used to disable / deactivate / shutdown / bring offline an interface for all vendor devices
    
    def get_cmd_disable_interface(self):
        # Function logic goes here
        return commandStr

    # Input:
    #    interface (string) - The name of the interface that is to be enabled
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Enable a specific interface
    # Output:
    #    resultsList (list) - Outputs all command results as displayed the client network device when enabling an interface
    
    def run_enable_interface_cmd(self, interface, activeSession):
        # Function logic goes here
        return resultsList

    # Input:
    #    interface (string) - The name of the interface that is to be disabled
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Disable a specific interface
    # Output:
    #    resultsList (list) - Outputs all command results as displayed the client network device when disabling an interface
    
    def run_disable_interface_cmd(self, interface, activeSession):
        # Function logic goes here
        return resultsList

    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Saves the running-configuration settings on the device into memory
    # Output:
    #    resultsList (list) - Outputs all command results as displayed the client network device when enabling an interface, with each new line (separated by carriage return) in its own line in the returned list
    
    def save_config_on_device(self, activeSession):
        # Function logic goes here
        return resultsList

    # Input:
    #    interface (string) - The name of the interface to edit the configuration settings
    #    datavlan (string) - The data vlan ID to set on the interface.  Note: This is an optional variable, and may submitted as an empty string instead
    #    voicevlan (string) - The voice vlan ID to set on the interface.  Note: This is an optional variable, and may submitted as an empty string instead
    #    other (list) - A list (separated by carriage returns) of any additional commands, manually entered by the user, needing to be configured for the specified interface.  Note: This is an optional variable, and may submitted as an empty string instead
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Edits the configuration settings for a specific interface on a device
    # Output:
    #    resultsList (list) - Outputs all command results as displayed the client network device when edit an interface, with each new line (separated by carriage return) in its own line in the returned list
    
    def run_edit_interface_cmd(self, interface, datavlan, voicevlan, other, activeSession):
        # Function logic goes here
        return resultsList

    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls any inventory information about the device (Cisco equivalent: "show inventory")
    # Output:
    #    resultsList (list) - Outputs all command results as displayed by the client network device as returned once executing the command, with each new line (separated by carriage return) in its own line in the returned list
    
    def pull_inventory(self, activeSession):
        # Function logic goes here
        return resultsList

    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls any version information about the device (Cisco equivalent: "show version")
    # Output:
    #    resultsList (list) - Outputs all command results as displayed by the client network device as returned once executing the command.  The list is formatted where each new line of output (as determined by \n [carriage-return]) is separated in the returned list.
    
    def pull_version(self, activeSession):
        # Function logic goes here
        return resultsList


Create Individual Devive Type Class
-----------------------------------

The specific device type class is used for the same vendor (as created above).  However a different device type file needs to be created for each type of device that uses different commands, unique commands, or returns output differently than other models by the same vendor.Currently, the only existing device type classeses are for Cisco, which are "cisco_ios.py", "cisco_asa.py", and "cisco_nxos.py".  Note that NetConfig support both IOS and IOS-XE, however their commands and outputs are identical, so they both use "cisco_ios.py".  In this example, we will create a new base device class for vendor "Acme".

Before creating any files, make sure to SSH in to the NetConfig server as user 'netconfig', or switch over to the user 'netconfig' once logging in.

.. code-block:: text

    su - netconfig

File Location
^^^^^^^^^^^^^

Create a new directory for the vendor.

.. code-block:: text

  mkdir ~/netconfig/app/device_classes/device_definitions/acme
  cd ~/netconfig/app/device_classes/device_definitions/acme

Create a new 'init' file

.. code-block:: text

    touch __init__.py
    vi __init__.py

Add the following lines into the file:

.. code-block:: python

    from acme_os import AcmeOS
    
    __all__ = ['AcmeOS']

Now create the new device file for Acme OS type devices:

.. code-block:: text

    touch acme_os.py
    vi acme_os.py

The basic structure of this file is as follows:

.. code-block:: python

    from ..acme_base_device import AcmeBaseDevice
    
    class AcmeOS(AcmeBaseDevice):
        # functions go here
        return x

The file has a few functions that are required by the overall NetConfig program.  As NetConfig grows its feature set, more required functions may be added, and will need to be added/updated in here as necessary.

All functions in here are expected to work with only this specific network device type, by this specific vendor.  Any functions that function identically, and are supported by this vendor across all of their device models/types, may go in the acme_base_device.py file instead.

Required Functions
""""""""""""""""""

These functions and their specific names are required for NetConfig, including the required inputs and expected outputs.  How they process the inputs in order to return the required output varies for each specific network vendor.

.. code-block:: python

    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls any version information about the device (Cisco equivalent: "show version")
    # Output:
    #    resultsList (list) - Outputs all command results as displayed by the client network device as returned once executing the command.  The list is formatted where each new line of output (as determined by \n [carriage-return]) is separated in the returned list.
    
    def pull_version(self, activeSession):
        # Function logic goes here
        return resultsList
    
    # Input: None required
    # Purpose: Provide the command used to display the active/running configuration settings
    # Output:
    #    commandStr (string) - Outputs the command used to display the active/running configuration settings
    
    def cmd_run_config(self):
        # Function logic goes here
        return commandStr
    
    # Input: None required
    # Purpose: Provide the command used to display the saved/startup configuration settings
    # Output:
    #    commandStr (string) - Outputs the command used to display the saved/startup configuration settings
    
    def cmd_start_config(self):
        # Function logic goes here
        return commandStr
    
    # Input: None required
    # Purpose: Provide the command used to display the the CDP/LLDP neighbors, with each new line (separated by carriage return) in its own line in the returned list
    # Output:
    #    commandStr (string) - Outputs the command used to display the CDP/LLDP neighbors
    
    def cmd_cdp_neighbor(self):
        # Function logic goes here
        return commandStr
    
    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls the active/running configuration settings for the device
    # Output:
    #    resultsList (list) - Outputs the active/running configuration settings, with each new line (separated by carriage return) in its own line in the returned list
    
    def pull_run_config(self, activeSession):
        # Function logic goes here
        return resultsList
    
    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls the saved/startup configuration settings for the device
    # Output:
    #    resultsList (list) - Outputs the saved/startup configuration settings, with each new line (separated by carriage return) in its own line in the returned list
    
    def pull_start_config(self, activeSession):
        # Function logic goes here
        return resultsList
    
    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls the CDP/LLDP neighbors for the device
    # Output:
    #    tableHeader (string) - String containing the table header lines, as retrieved from (usually) the first line of output, with each category separated by comma.
    #        Example: Hostname,Src Port,Model,Dest Port,etc
    #    tableBody (list) - List with each line an output row retrieved from the devices CDP/LLDP table.  Each column separated by comma.  There should be the same number of columns in each row, and the same number of columns as in the tableHeader.
    Outputs the CDP/LLDP neighbors, with each new line (separated by carriage return) in its own line in the returned list
    
    def pull_cdp_neighbor(self, activeSession):
        # Function logic goes here
        return tableHeader, tableBody
    
    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls different information about a device, stored into 3 separate lists:
    #    interfaceConfig (list) - Configuration settings for the interface
    #    interfaceMacAddressesHeader (string) - A string containing the table header for the MAC Address table output, with each column separated by a comma
    #    interfaceMacAddressesBody (list) - A list with each row containing each line of data in the interface MAC Address table output, with each column separated by a comma.  Note: This should only be run on devices that store MAC addresses associated with their interface.  Otherwise simply return an empty string
    #    interfaceStatistics (list) - Any relevant interface statistics that should be shown for the interface (Cisco example: show interface FastEthernet0/1)
    # Output:
    #    interfaceConfig, interfaceMacAddressesHeader, interfaceMacAddressesBody, interfaceStatistics (lists) - Array specifics detailed above
    
    def pull_interface_info(self, activeSession):
        # Function logic goes here
        return interfaceConfig, interfaceMacAddressesHeader, interfaceMacAddressesBody, interfaceStatistics
    
    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls the current device uptime
    # Output:
    #    resultsStr (string) - Outputs the current uptime of the device as a string
    
    def pull_device_uptime(self, activeSession):
        # Function logic goes here
        return resultsStr
    
    # Input:
    #    activeSession (Netmiko class) - The active, existing SSH session for a device, stored as a Netmiko class
    # Purpose: Pulls the list of interfaces on the device
    # Output:
    #    tableHeader (string) - String containing the table header lines.
    #    resultsList (list) - Outputs a list of interfaces and relevant status settings, with each new line (separated by carriage return) in its own line in the returned list (Cisco example: "show ip interface brief")
    
    def pull_host_interfaces(self, activeSession):
        # Function logic goes here
        return tableHeader, resultsList
    
    # Input:
    #    interfaces (list) - Array of strings, returned from the device, where each string contains information on if the interface is up/online, down/offline, and administratively down/forced offline.  This function does not correctly interface status with the interface directly, so tracking the interface names is irrelevant here
    # Purpose: Returns the number of interfaces online, offline, forced offline, and total count
    # Output:
    #    upCount (int) - Total number of interfaces active/online
    #    downCount (int) - Total number of interfaces down/offline
    #    disabledCount (int) - Total number of interfaces administratvely down/forced offline
    #    totalCount (int) - Total number of interfaces
    
    def count_interface_status(self, interfaces):
        # Function logic goes here
        return upCount, downCount, disabledCount, totalCount

