#!/bin/sh

VBOX_CMD=$(which vboxmanage)

VM_NAME=
VM_TYPE=

INST_FILE=

MEM_SIZE=128

HD_SIZE=10000
HD_FILE="~/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"

RDP_PORT=3389

echo Creating VM
$VBOX_CMD createvm --name $VM_NAME --ostype $VM_TYPE --register

echo Creating HD
$VBOX_CMD createhd --filename "$HD_FILE" --size $HD_SIZE

echo Adding IDE Controller
$VBOX_CMD storagectl $VM_NAME --name "IDE Controller" --add ide --controller PIIX4

echo Attaching HD
$VBOX_CMD storageattach $VM_NAME --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$HD_FILE"

echo Attaching DVD
$VBOX_CMD storageattach $VM_NAME --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium $INST_FILE

echo Setting RDP Port
$VBOX_CMD modifyvm $VM_NAME --vrdeport $RDP_PORT

echo Enabling RDP
$VBOX_CMD modifyvm $VM_NAME --vrde on

echo Setting Memory Size
$VBOX_CMD modifyvm $VM_NAME --memory $MEM_SIZE

echo Powering on VM
$VBOX_CMD startvm $VM_NAME --type headless
