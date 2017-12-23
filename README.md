# EasyVM Library #

A library of sample VM templates.


## Before you begin ##

This tool makes it easy to create Windows VM templates.  Please make sure that you are following the terms of the license agreements under which you obtained your Windows media.


## Installing EasyVM ##

1. Clone this repo (easyvm-library) into a folder:

        git clone --recursive https://github.com/nerdile/easyvm-library

2. Bootstrap your library folder.

        copy -Recurse library-checkedin library

3. Build your Template VHD's.  (See "Building Template VHD's" later in this page.)

4. Open an elevated PowerShell window on your Hyper-V host.

        cd \path\to\easyvm-library
        import-module .\easyvm\easyvm.psm1
        Deploy-EasyVM mytestvm1 -Template client -NoDomainJoin

5. When prompted, enter:
   - the full path to your library folder
   - the local path where you want to store the real VM's you create
   - the vSwitch you want to use for your Windows VM's
   - EasyVM will not ask you for these values more than once.  If you want to change your settings, you can update the settings in the Registry under HKLM\Software\Awesome\EasyVM.

6. When prompted, enter:
   - the new local Administrator password for the VM

7. EasyVM will prepare the VM.  A new VM window should soon appear.  The VM will boot and set itself up.  Depending on the speed of your CPU and hard drive, it may take around 10 minutes for the VM to fully set up.

8. Once you've set this up initially, you can very quickly create additional VM's by starting at step 4.  You can also share out your templates with others in your workgroup, so that they can easily create these VM's as well.


## Building Template VHD's ##

Convert-WindowsImage.ps1 converts Windows ISO's to generalized Windows VHD's.  These VHD's will specialize as soon as they are booted into.  You can use Convert-WindowsImage.ps1 manually to create the images one at a time.

1. Gather the ISO's for the versions of Windows you want to template. 
   - You can get these from My Visual Studio (formerly MSDN), Windows Insider, the Volume License portal, or the [Windows Media Creator Tool](https://www.bing.com/search?q=windows+media+creation+tool).

2. In library-vhds.xml, update the list of /library/mediasearchfolders to the local or network paths where you keep Windows ISO's.  Note: These folders will be searched recursively.

3. Update /library/sourcemedia to match the names of your ISO's.  (The default patterns match the downloads from MSDN.)
   - Note: You can have multiple patterns.  This can be helpful if your organization has Windows ISO's already shared, but with different filenames.

4. Update /library/targetvhds to be the list of VHD images you want in your library.  The default is Windows 10 Enterprise 1709 and Windows Server 2016, both Gen2/amd64, but there are other examples that are commented out.

5. In PowerShell, cd into your easyvm-library folder and run:

        ./Build-LibraryVhds.ps1


## Sharing your templates with a team ##

You'll need to share two folders:
- The tools that need to be installed on each Hyper-V host
    - Run .\Build-ToolsFolder.ps1 to build a tools\ folder that contains only the files needed by remote clients.
- The library of VM templates (VHD's and tasks)

See .\Share-EasyVMFiles.ps1 for an example of how to create these file shares in PowerShell.


## Creating your own templates ##

A Template is a folder within library\template, which consists of:
- template.xml, which specifies:
    - Base VHD image: Filename within library\vhd, without the vhd/vhdx extension.  .vhd will be used for Gen1 VM's, and .vhdx will be used with Gen2 VM's.
    - Product key: If this is omitted, it must be passed manually to Deploy-EasyVM.  In general, you should only put the key in the template if it is a default product key (allows installation but does not activate), an AVMA key, or a [KMS volume license](https://technet.microsoft.com/en-us/library/jj612867(v=ws.11).aspx) key.
    - List of tasks to install:  Folders within library\tasklibrary.
- unattend.xml (Optional): If you want to use a different unattend.xml than the default one in the library.

A Task is a folder within library\tasklibrary, that will be copied onto the VM, and then installed as part of the VM setup process.  It consists of:
- task.xml, which specifies:
    - @name: the friendly name of the task
    - @reboot: optional parameter that indicates that the VM needs to reboot before installing the next task.
- install.bat, cmd, ps1, exe
- Any other files needed to install the task.

The task folder will be copied directly to the VM.  As part of VM setup, the install file will be run, elevated, from the task directory.  When the install script exits, the task folder will be deleted from the VM.

Examples of what a task might include:
- A single PS1 file to install an optional Windows component or role, like IIS.
- kitchensink.msi and an install.bat file that contains: "msiexec /qb /i .\kitchensink.msi"


## Extending EasyVM ##

The easiest way to extend EasyVM is to create your own templates and tasks.

If you want to provide more dynamic tasks, consider creating your own PowerShell script that wraps Deploy-EasyVM, rather than forking EasyVM.

Examples of things you can do in your own PowerShell scripts:
- Dynamic tasks:  You can create a task folder on the fly and pass it as an absolute path to Deploy-EasyVM -AddTask.  For example, you might want find the latest build of your product installer from your build share.
- Override VHD:  You can substitute a VHD of the same generation and architecture by passing -OverrideVHD.  For example, you might want to try an existing template with the latest Windows Insider VHD.
